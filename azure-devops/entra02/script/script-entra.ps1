param (
    [Parameter(Mandatory)]
    [Alias('Entra Id Group')]
    [String]$group,

    [Parameter(Mandatory)]
    [Alias('Add or Remove')]
    [String]$addorremove,

    [Parameter(Mandatory)]
    [Alias('Management Group Id')]
    [String]$objectid
)

az ad group member check --group $group --member-id $objectid

if ($addorremove -eq 'add') {

    az ad group member add --group $group --member-id $objectid
    Write-Output "Added $objectid to $group"
}

if ($addorremove -eq 'remove') {

    az ad group member remove --group $group --member-id $objectid
    Write-Output "Removed $objectid from $group"
}

az ad group member check --group $group --member-id $objectid

