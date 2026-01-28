param (
    [Parameter(Mandatory)]
    [Alias('Subscription Name')]
    [String]$SubName,

    [Parameter(Mandatory)]
    [Alias('DevOps Project Name')]
    [String]$DevopsProjectName,

    [Parameter(Mandatory)]
    [Alias('Management Group Id')]
    [String]$MgName,

    [Parameter(Mandatory)]
    [Alias('Billing Account Id')]
    [String]$billingAccounts,

    [Parameter(Mandatory)]
    [Alias('Billing Profile')]
    [String]$billingProfile,

    [Parameter(Mandatory)]
    [Alias('Invoice Section')]
    [String]$invoiceSections
)

if ($null -eq $billingAccounts -or $null -eq $billingProfile -or $null -eq $invoiceSections) {
    Write-Error "Billing information environment variables are not set."
    exit 1
}
"billingAccounts: $($billingAccounts.Substring(0,10))"
"billingProfile: $($billingProfile.Substring(0,10))"
"invoiceSections: $($invoiceSections.Substring(0,10))"
$billingScope = "/providers/Microsoft.Billing/billingAccounts/$billingAccounts/billingProfiles/$billingProfile/invoiceSections/$invoiceSections"
$rbac = "Owner"
$devopsOrg = "https://dev.azure.com/ABCse"
$devopsOrgName = "ABCse"
$projectId = az devops project show --project $DevopsProjectName --org $devopsOrg --query "id" --output tsv
"projectId: $projectId"
$tenantID = az account show --query "tenantId" -o tsv
"tenantID: $tenantID"
$token = az account get-access-token --query accessToken --output tsv
if (!$token) {
    Write-Error "Failed to acquire access token."
    exit 1
}
"token: $($token.Substring(1,20))"

if ($SubName -ne 'dont-create-subscriptions') {
    #Create subscriptions
    if ($SubName -match "-prod-") {
        $Alias = az account alias create --name $SubName --billing-scope $billingScope --display-name $SubName --workload 'Production' -o tsv
        "Created Production alias $Alias"
    }
    else {
        $Alias = az account alias create --name $SubName --billing-scope $billingScope --display-name $SubName --workload 'DevTest' -o tsv
        "Created DevTest alias $Alias"
    }

    $spiname = ($SubName).Replace('sub', 'sp')
    $spiname

    # Create Service Principal
    $appId = az ad app create --display-name $spiname --query "appId" -o tsv

    "appId: $appId"
    "ObjectId: $ObjectId"

    if (!(az ad sp show --id $appId)) {
        az ad sp create --id $appId -o tsv --query "id"
        "Created Service Principal for appId: $appId"
    }
    # Assign the Service Principal, "Contributor" RBAC on Subscription Level:-
    #Stopped working:
    # $newSub = az account alias show --name $SubName --query "properties.subscriptionId" -o tsv
    $newSub = az account subscription list --query "[?state=='Enabled' && displayName=='$SubName'].subscriptionId" -o tsv
    if (!$newSub) {
        Write-Error "Failed to retrieve subscription ID for $SubName."
        exit 1
    }
    "newSub: $newSub"

    az role assignment create --assignee "$appId" --role "$rbac" --scope "/subscriptions/$newSub" -o table
    "Assigned $rbac role to $appId on subscription $newSub "

    # Set Default DevOps Organisation and Project:-
    az devops configure --defaults organization=$devopsOrg project=$DevopsProjectName -o table
    "Set default DevOps organization to $devopsOrg and project to $DevopsProjectName"

    #Add subscriptions to management group
    ##az account management-group subscription add --name "mg-landingzones-01" --subscription $newSub -o table
    ##az account management-group subscription show-sub-under-mg --name "mg-landingzones-01" --query "[?displayName=='$SubName'].{subName: displayName, mgName:'mg-landingzones-01'}" -o table 

    # Update DevOps Service Connection with Federated Credentials:-
    $serviceEndpointId = az devops service-endpoint list --org $devopsOrg --project $DevopsProjectName --query "[?name=='$spiname'].id" -o tsv
    "serviceEndpointId: $serviceEndpointId"
    $authorization = az devops service-endpoint list --org $devopsOrg --project $DevopsProjectName --query "[?name=='$spiname'].authorization.scheme" -o tsv
    "authorization: $authorization"
    if ($serviceEndpointId) {
        Write-Output "Found service endpoint: $serviceEndpointId"
        if ($authorization -notmatch "WorkloadIdentityFederation") {
            Write-Output "Configuring Workload Identity Federation"
            $uri = "https://dev.azure.com/$devopsOrgName/$DevopsProjectName/_apis/serviceendpoint/endpoints/${serviceEndpointId}?operation=ConvertAuthenticationScheme&api-version=7.2-preview.4"
            $body = ConvertTo-Json -Depth 10 @{
                type                             = "azurerm"
                authorization                    = @{
                    scheme = "WorkloadIdentityFederation"
                }
                serviceEndpointProjectReferences = @(
                    @{
                        name             = $spiname
                        projectReference = @{
                            id   = $projectId
                            name = $DevopsProjectName
                        }
                    }
                )
            }
            Invoke-RestMethod  -Method PUT -Uri $uri  -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } -Body $body
            "Updated service endpoint to Workload Identity Federation"
        }
    }
    else {
        Write-Output "Creating service endpoint"
        $uri = "https://dev.azure.com/$devopsOrgName/$DevopsProjectName/_apis/serviceendpoint/endpoints?api-version=7.1-preview.4"
        $body = ConvertTo-Json -Depth 10 @{
            type                             = "azurerm"
            name                             = $spiname
            authorization                    = @{
                scheme     = "WorkloadIdentityFederation"
                parameters = @{
                    tenantid           = $tenantID
                    serviceprincipalid = $appId #$spiID
                }
            }
            data                             = @{
                subscriptionId   = $newSub
                subscriptionName = $SubName
                environment      = "AzureCloud"
                scopeLevel       = "Subscription"
            }
            serviceEndpointProjectReferences = @(
                @{
                    name             = $spiname
                    projectReference = @{
                        id   = $projectId
                        name = $DevopsProjectName
                    }
                }
            )
        }
        $NewSe = Invoke-RestMethod  -Method POST -Uri $uri -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } -Body $body
        $Issuer = $NewSe.authorization.parameters.workloadIdentityFederationIssuer 
        $Subject = $NewSe.authorization.parameters.workloadIdentityFederationSubject 
        "Created service endpoint with Workload Identity Federation"
    }

    $app = az ad app federated-credential list --id $appId --query "[?name=='devops'].id" -o tsv

    if ($app) {
        Write-Output "Federated credentials exist"
    }
    else {
        $url = "https://graph.microsoft.com/v1.0/applications?`$filter=appId eq '$appId'"
        $headers = "Content-type=application/json"
        $ObjectId = az rest --method get --uri $url --headers $headers --query "value[0].id" -o tsv
        if (!$ObjectId) {
            Write-Error "Failed to retrieve Object ID for appId: $appId."
            exit 1
        }

        $FedParameters = @{
            name      = "devops"
            issuer    = "$Issuer"
            subject   = "$Subject"
            audiences = @("api://AzureADTokenExchange")
        } | ConvertTo-Json -Depth 10
        # az ad app federated-credential create --id $appId --parameters $FedParameters
        $url = "https://graph.microsoft.com/v1.0/applications/$ObjectId/federatedIdentityCredentials"
        $headers = "Content-type=application/json"
        $FedParameters | az rest --method post --uri $url --headers $headers --body '@-'
    }

    # #Add subscriptions to management group
    # $newSub = az account list --query "[?name=='$SubName'].id" -o tsv
    # $timeout = New-TimeSpan -Seconds 30
    # $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    # while (!(az account management-group subscription show --name "mg-landingzones-01" --subscription "$newSub") -or $stopwatch.elapsed -lt $timeout) {
    #     try {
        
    #         az account management-group subscription add --name "mg-landingzones-01" --subscription "$newSub" -o table
    #         Start-Sleep 5
    #     }
    #     catch {}
    # }
    # Write-Output "$SubName moved to mg-landingzones-01"

    az automation runbook start `
        --automation-account-name "aa-infra-mgmt-prod-we-01" `
        --name "run-MoveToNewManagementGroup01" `
        --parameters SUBNAME=$SubName NEWMG=$MgName `
        --resource-group "rg-infra-mgmt-prod-we-01" `
        --subscription "xyz"
}
else {
    Write-Output "Skipped creation of subscription"
}
