param (
    [Parameter(Mandatory)]
    [Alias('Entra Group Name')]
    [String]$GroupName
)

$Group = az ad group list --query "[?displayName=='$GroupName']" -o tsv
if ($null -eq $Group) {
    $GroupId = az ad group create --display-name $GroupName --mail-nickname $GroupName --query 'id' -o tsv
    Write-Output "Created $GroupName"
    Write-Output "$GroupName : $GroupId"
}
else {
    Write-Output "$GroupName already exists"
}
