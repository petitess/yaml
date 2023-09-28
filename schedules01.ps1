schedules:
- cron: '*/1 * * * *'
  displayName: Daily midnight build
  branches:
    include:
    - main
    
pr: none
trigger: none

pool:
  vmImage: ubuntu-22.04

variables:
  azureSubscription: 'sub-labb-01'

parameters:
  - name: environment
    type: string
    default: labb

stages:
  - stage: build
    displayName: Build
    jobs:
      - job: iac
        displayName: Validate infrastructure
        steps:
          - task: AzureCLI@2
            displayName: ${{ parameters.environment }}
            inputs:
              azureSubscription: $(azureSubscription)
              scriptType: pscore
              scriptPath: main/deploy.ps1
              arguments: ${{ parameters.environment }} validate
