### loop-ci.yaml
```yaml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - ci/loop-ci.yaml
      - iac

pool:
  #vmImage: ubuntu-latest
  name: 'vmmgmtprod0x' 
  demands: 
    - Agent.Name -equals agent_vm01_250122_1
    - USERNAME -equals VMMGMTPROD01$

variables:
  azureSubscription: sp-sub-labb-01
  workingDirectory: iac

parameters:
  - name: environments
    type: object
    default:
      - copilot
      - license
      - dev
      - test
      - prod

schedules:
- cron: '0 21 * * sun'
  displayName: "automatiserad"
  always: true
  branches:
    include:
      - main

stages:
  - stage: what-if
    displayName: What-If
    jobs:
      # - job: install_bicep
      #   displayName: install_bicep
      #   steps:
      #     - task: PowerShell@2
      #       name: bicep
      #       displayName: install bicep
      #       inputs:
      #         targetType: 'inline'
      #         script: |
      #           mkdir /home/vsts/work/_temp/.azclitask
      #           mkdir /home/vsts/work/_temp/.azclitask/bin
      #           curl -Lo /home/vsts/work/_temp/.azclitask/bin/bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64
      #           chmod +x /home/vsts/work/_temp/.azclitask/bin/bicep
      
      - job: iac
        displayName: What-if
        steps:
          - ${{ each env in parameters.environments }}:
            - task: AzureCLI@2
              displayName: ${{ env }}
              inputs:
                azureSubscription: $(azureSubscription)
                scriptType: pscore
                scriptPath: $(workingDirectory)/validate.ps1
                scriptArguments: ${{ env }}
                workingDirectory: $(workingDirectory)
    
  - stage: deploy
    displayName: Deploy Non-prod
    jobs:      
      - job: iac
        displayName: Deploy
        steps:
          - ${{ each env in parameters.environments }}:
            - ${{ if ne(env, 'prod') }}:
              - task: AzureCLI@2
                displayName: ${{ env }}
                inputs:
                  azureSubscription: $(azureSubscription)
                  scriptType: pscore
                  scriptPath: $(workingDirectory)/deploy.ps1
                  scriptArguments: ${{ env }}
                  workingDirectory: $(workingDirectory)
```
### loop-cd.yaml
```yaml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - ci/loop-cd.yaml
      - iac

pool:
  vmImage: ubuntu-latest

variables:
  azureSubscription: sp-sub-labb-01
  workingDirectory: iac

parameters:
  - name: environments
    type: object
    default:
      - prod

schedules:
- cron: '0 21 * * sun'
  displayName: "automatiserad"
  always: true
  branches:
    include:
      - main

stages:
  - stage: deploy prod
    displayName: Deploy prod
    jobs:    
      - job: iac
        displayName: Deploy
        steps:
          - ${{ each env in parameters.environments }}:
            - task: AzureCLI@2
              displayName: ${{ env }}
              inputs:
                azureSubscription: $(azureSubscription)
                scriptType: pscore
                scriptPath: $(workingDirectory)/deploy.ps1
                scriptArguments: ${{ env }}
                workingDirectory: $(workingDirectory)
```
