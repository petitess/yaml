#!/usr/bin/env pwsh

param (
    [Parameter(Mandatory)]
    [String]
    $Environment
)

$ErrorActionPreference = 'Stop'

$ConfigFile = Join-Path 'environments' "$Environment.config.json"
$Config = Get-Content $ConfigFile | ConvertFrom-Json

$Timestamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$Repo = Split-Path -Leaf (git remote get-url origin).Replace('.git', '')
$DeploymentName = '{0}-{1}_{2}' -f $Repo, $Environment, $Timestamp

$ParameterFile = Join-Path 'environments' "$Environment.parameters.json"

Set-AzContext -Subscription $Config.subscriptionId

$Arguments = @{
    Name                        = $DeploymentName
    TemplateFile                = $Config.templateFile
    TemplateParameterFile       = $ParameterFile
    Location                    = $Config.location
    SkipTemplateParameterPrompt = $true
}

Test-AzSubscriptionDeployment @Arguments

$Output = Get-AzSubscriptionDeploymentWhatIfResult @Arguments
$Output | Select-Object -ExcludeProperty Changes
$Output.Changes
