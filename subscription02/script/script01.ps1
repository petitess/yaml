
$billingAccounts = 'xxxxxxxxxx-3b42-53ba-e814-421e30e28525:1346c60a-08c0-4567-a607-xxxxxxx'
$billingProfile = 'xxxx-Y3PM-BG7-xxx'
$invoiceSections = 'xxxx-TWIN-PJA-xxx'
$billingScope = "/providers/Microsoft.Billing/billingAccounts/$billingAccounts/billingProfiles/$billingProfile/invoiceSections/$invoiceSections"

Set-Location $PSScriptRoot

$names = Get-Content -Path ..\subscriptionsNames.txt

$rbac = "Owner"
$devopsOrg = "https://dev.azure.com/xxxx"
$devopsPrj = "AzureIAC"
$tenantID = az account show --query "tenantId" -o tsv

foreach ($sub in $names) {
    #Create subscriptions
    az account alias create --name $sub --billing-scope $billingScope --display-name $sub --workload 'Production' 
    $newSub = az account alias show --name $sub --query "properties.subscriptionId" -o tsv

    #Add subscriptions to management group
    az account management-group subscription add --name "mg-sek-prod-01" --subscription $newSub

    $spiname = "sp-$sub"

    $spipasswd = az ad sp create-for-rbac -n $spiname --query "password" -o tsv

    # Query the Application ID of the Service Principal and Store it in a variable:-
    $spiID = az ad sp list --display-name $spiname --query [].appId -o tsv
    
    # Assign the Service Principal, "Contributor" RBAC on Subscription Level:-
    az role assignment create --assignee "$spiID" --role "$rbac" --scope "/subscriptions/$newSub"
    
    #Set Service Principal Secret as an Environment Variable for creating Azure DevOps Service Connection:-
    $env:AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY = $spipasswd
    
    # Perform DevOps Login. It will Prompt for PAT:-
    #az devops login
    
    # Set Default DevOps Organisation and Project:-
    az devops configure --defaults organization=$devopsOrg project=$devopsPrj
    
    # Create DevOps Service Connection:-
    az devops service-endpoint azurerm create --azure-rm-service-principal-id $spiID --azure-rm-subscription-id $newSub --azure-rm-subscription-name $sub --azure-rm-tenant-id $tenantID --name $spiname --org $devopsOrg --project $devopsPrj
    
    # Grant Access to all Pipelines to the Newly Created DevOps Service Connection:-
    $srvEndpointID = az devops service-endpoint list --query "[?name=='$spiname'].id" -o tsv
    az devops service-endpoint update --id $srvEndpointID --enable-for-all
}