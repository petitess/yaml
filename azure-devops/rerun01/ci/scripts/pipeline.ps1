param (
    [String]$DevOpsOrg,
    [String]$DevopsProject,
    [string]$PipelineName = 'deploy-error'
)

for ($i = 20; $i -gt 0; $i -= 10) {
    Write-Host "Sleeping... $i seconds remaining"
    Start-Sleep -Seconds 10
}

$Runs = az pipelines runs list --org $DevOpsOrg --result 'failed' --project $DevopsProject --query "[?definition.name=='$PipelineName' && contains(startTime, '$(Get-Date -Format "yyyy-MM-dd")')]" 

Write-Warning "Failed pipeline count: $(($Runs | ConvertFrom-Json).Count)"

if (($Runs | ConvertFrom-Json).Count -lt 13) {
    ($Runs | ConvertFrom-Json)[0] | ForEach-Object {
        az pipelines run --org $DevOpsOrg --project $DevopsProject --branch 'main' --id $_.definition.id --query definition
        Write-Host "Started pipeline: $($_.definition.id)"
    }
}
else {
    Write-Warning "The pipeline $PipelineName failed multiple times. Correct the code manually."
}





