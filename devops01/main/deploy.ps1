#!/usr/bin/env pwsh

param (
    [Parameter(Mandatory)]
    [String]$Environment,

    [ValidateSet('validate', 'what-if', 'create')]
    [String]$Command = 'create'
)

$ErrorActionPreference = 'Stop'

Set-Location $PSScriptRoot

$ConfigFile = Join-Path '..' 'config' "$Environment.config.json"
$Config = Get-Content $ConfigFile | ConvertFrom-Json

$Repository = Split-Path -Leaf (git remote get-url origin).TrimEnd('.git')
$Commit = git rev-parse --short HEAD
$Timestamp = Get-Date -UFormat %s

$DeploymentName = $Repository, $Environment, $Commit, $Timestamp | Join-String -Separator _
$TemplateFile = 'main.bicep'
$ParameterFile = Join-Path 'parameters' "$Environment.bicepparam"

$Env:Timestamp = $Timestamp

az deployment sub $Command `
    --name $DeploymentName `
    --subscription $Config.subscription `
    --location $Config.location `
    --template-file $TemplateFile `
    --parameters $ParameterFile `
    --no-prompt `
    --output table