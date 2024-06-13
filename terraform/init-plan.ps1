#!/usr/bin/env pwsh

param (
    [Parameter(Mandatory)]
    [String]$Environment
)

$ErrorActionPreference = 'Stop'

Set-Location $PSScriptRoot

$SubId = $(az account show --name 'sub-default-01' --query id -o tsv)
$TenantId = $(az account show --query tenantId -o tsv)

Write-Host "ENV: $Environment"
Write-Host "SUB: $($SubId.Substring(0, 15))"
Write-Host "TEN: $($TenantId.Substring(0, 15))"


terraform init -input=false `
    -backend-config="storage_account_name=stgithubprod01" `
    -backend-config="subscription_id=$SubId" `
    -backend-config="tenant_id=$TenantId"

terraform plan -out=tfplan -input=false -var="env=$Environment" -var="sub_id=$SubId"