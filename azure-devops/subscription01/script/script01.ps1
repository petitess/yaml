param (
    [Parameter(Mandatory)]
    [Alias('Subscription Name')]
    [String]$SubName,

    [Parameter(Mandatory)]
    [Alias('DevOps Project Name')]
    [String]$DevopsProjectName,

    [Parameter(Mandatory)]
    [Alias('Management Group Id')]
    [String]$MgName
)

$billingAccounts = 'x-e666-4fd2-b303-98219d087695_2019-05-31'
$billingProfile = 'X-PGB'
$invoiceSections = 'X-PGB'
$billingScope = "/providers/Microsoft.Billing/billingAccounts/$billingAccounts/billingProfiles/$billingProfile/invoiceSections/$invoiceSections"
$rbac = "Owner"
$devopsOrg = "https://dev.azure.com/ABCse"
$devopsOrgName = "ABCse"
$projectId = az devops project show --project $DevopsProjectName --query "id" --output tsv
$tenantID = az account show --query "tenantId" -o tsv
$issuer = "https://vstoken.dev.azure.com/X-c6832fa0baa0"
$token = az account get-access-token --query accessToken --output tsv

if ($SubName -ne 'dont-create-subscriptions') {
    #Create subscriptions
    if ($SubName -match "-prod-") {
        az account alias create --name $SubName --billing-scope $billingScope --display-name $SubName --workload 'Production' -o table
    }
    else {
        az account alias create --name $SubName --billing-scope $billingScope --display-name $SubName --workload 'DevTest' -o table
    }

    $spiname = ($SubName).Replace('sub', 'sp')

    # Create Service Principal
    $appId = az ad app create --display-name $spiname --query "appId" -o tsv

    if (!(az ad sp show --id $appId)) {
        az ad sp create --id $appId
    }
    # Assign the Service Principal, "Contributor" RBAC on Subscription Level:-
    $newSub = az account alias show --name $SubName --query "properties.subscriptionId" -o tsv
    az role assignment create --assignee "$appId" --role "$rbac" --scope "/subscriptions/$newSub" -o table

    # Set Default DevOps Organisation and Project:-
    az devops configure --defaults organization=$devopsOrg project=$DevopsProjectName -o table

    #Add subscriptions to management group
    ##az account management-group subscription add --name "mg-landingzones-01" --subscription $newSub -o table
    ##az account management-group subscription show-sub-under-mg --name "mg-landingzones-01" --query "[?displayName=='$SubName'].{subName: displayName, mgName:'mg-landingzones-01'}" -o table 

    $app = az ad app federated-credential list --id $appId --query "[?name=='devops'].id" -o tsv

    if ($app) {
        Write-Output "Federated credentials exist"
    }
    else {
        az ad app federated-credential create --id $appId --parameters `
            "{\""name\"": \""devops\"", \""issuer\"": \""$issuer\"", \""subject\"": \""sc://$devopsOrgName/$DevopsProjectName/$spiname\"", \""audiences\"": [\""api://AzureADTokenExchange\""]}" -o table
    }

    # Update DevOps Service Connection with Federated Credentials:-
    $serviceEndpointId = az devops service-endpoint list --org $devopsOrg --project $DevopsProjectName --query "[?name=='$spiname'].id" -o tsv
    $authorization = az devops service-endpoint list --org $devopsOrg --project $DevopsProjectName --query "[?name=='$spiname'].authorization.scheme" -o tsv
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
        }
    }
    else {
        # Create DevOps Service Connection with Federated Credentials:-
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
    
        Invoke-RestMethod  -Method POST -Uri $uri -Headers @{ Authorization = "Bearer $token"; "Content-Type" = "application/json" } -Body $body
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
        --subscription "X-d700d0bc3e66"
}
else {
    Write-Output "Skipped creation of subscription"
}