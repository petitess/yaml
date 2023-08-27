# Introduction
This repository contains *Infrastructure-as-Code (IaC)* templates that declaratively define Azure infrastructure.  
The templates are written in [Bicep](https://github.com/Azure/bicep) and can be deployed either manually or in a CI/CD pipeline.

<br>

# Getting Started

### Prerequisites
In order to deploy this project you will need an account that is assigned the directory roles `Application Administrator`, `Privileged Role Administrator` and `User Administrator` in the `Azure AD` tenant and also the Azure role `Owner` on the subscriptions in use.

There are also a number of prerequisites that need to be installed on your local machine before you can succesfully manage and deploy this project.  
Simply follow the instructions below for the operating system in use.

### `Windows`

#### 1. Install `Git`, `Visual Studio Code`, `Bicep`, and the latest version of `PowerShell Core` by running the following cmdlets in an elevated `PowerShell` prompt:
```powershell
winget install Git.Git
winget install Microsoft.VisualStudioCode
winget install Microsoft.PowerShell
winget install Microsoft.Bicep
```


#### 2. Install the following `Azure modules` and `Visual Studio Code extensions` in the `Powershell` prompt:

The Azure modules:
```powershell
Install-Module Az
```

The Visual Studio Code extensions:
```powershell
code --install-extension waderyan.gitblame
code --install-extension redhat.vscode-yaml
code --install-extension ms-vscode.powershell
code --install-extension yzhang.markdown-all-in-one
code --install-extension ms-azuretools.vscode-bicep
code --install-extension gurumukhi.selected-lines-count
code --install-extension josin.kusto-syntax-highlighting
code --install-extension ms-azure-devops.azure-pipelines
code --install-extension msazurermtools.azurerm-vscode-tools
```
#### 3. Generate Git credentials from `Azure DevOps`:
[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> \<repo-name\> -> Clone -> Generate Git credentials
### 4.Rune the following code line by line to clone the Git repository to your computer:
```powershell
cd <path-to-where-to-save-the-project>
git clone <url>
```
#### 6. Open `Visual Studio Code` from the current working directory:
```powershell
code .
```
### `Linux`
#### 1. Run the following code block to install all prerequisites:
```shell
read -p "Firstname Lastname: " userName ; read -p "Email: " userEmail

sudo apt update

sudo apt install -y jq

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

sudo apt install -y git &&
    git config --global user.name "${userName}" &&
    git config --global user.email "${userEmail}" &&
    git config --global credential.helper "cache --timeout=86400"
```

#### 2. Get the Git Clone URL from `Azure DevOps`:
[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> \<repo-name\> -> Clone -> Copy clone URL to clipboard


#### 3. Generate Git credentials from `Azure DevOps`:
[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> \<repo-name\> -> Clone -> Generate Git credentials

#### 4. Run the following code line by line to clone the Git repository to your computer:
```shell
read -p "Git Clone URL: " cloneUrl

path=~/repos

mkdir -p "${path}" &&
    cd "${path}"

git clone "${cloneUrl}"
```

#### 5. Customize shell prompt to include current Git branch (Optional):
```shell
vim ~/.bashrc

# Add the following line of code:
export PS1="\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[00;35m\]\w\[\033[36m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')\[\033[00m\] $ "
```

<br>

### `Mac`

#### 1. Run the following code blocks one by one to install all prerequisites:
```shell
read -p "Firstname Lastname: " userName ; read -p "Email: " userEmail
```

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/main/install)"

brew install bash

if [[ -z "$(cat /etc/shells | grep -- /usr/local/bin/bash)" ]]; then
    echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
fi

chsh -s /usr/local/bin/bash ; sudo chsh -s /usr/local/bin/bash
```

```shell
brew install coreutils

brew install jq

brew install azure-cli

brew install git &&
    git config --global user.name "${userName}" &&
    git config --global user.email "${userEmail}" &&
    git config --global credential.helper osxkeychain

brew cask install visual-studio-code && (
    code --install-extension waderyan.gitblame
    code --install-extension redhat.vscode-yaml
    code --install-extension ms-vscode.powershell
    code --install-extension yzhang.markdown-all-in-one
    code --install-extension ms-azuretools.vscode-bicep
    code --install-extension gurumukhi.selected-lines-count
    code --install-extension josin.kusto-syntax-highlighting
    code --install-extension ms-azure-devops.azure-pipelines
    code --install-extension msazurermtools.azurerm-vscode-tools
)
```

#### 2. Get the Git Clone URL from `Azure DevOps`:
[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> \<repo-name\> -> Clone -> Copy clone URL to clipboard

#### 3. Generate Git credentials from `Azure DevOps`:
[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> \<repo-name\> -> Clone -> Generate Git credentials

#### 4. Run the following code line by line to clone the Git repository to your computer:
```shell
read -p "Git Clone URL: " cloneUrl

path=~/repos

mkdir -p "${path}" &&
    cd "${path}"

git clone "${cloneUrl}"
```

#### 5. Customize shell prompt to include current Git branch (Optional):
```shell
vim ~/.bash_profile

# Add the following line of code:
export PS1="\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[00;35m\]\w\[\033[36m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')\[\033[00m\] $ "
```

#### 6. Open `Visual Studio Code` from the current working directory:
```shell
code .
```
# Build and Test
## Compatible versions

The following software versions have been tested and verified to be compatible with this project:

| Software   | Version      |
| ---------- | ------------ |
| Windows    | 11 (22H2)    |
| xLinux     | Ubuntu 22.10 |
| xmacOS     | 11.3.1       |
| Powershell | 7.3.4        |
| azure CLI  | 2.45.0       |
| git        | 2.39.1       |
| xHomebrew  | 3.1.9        |
| VSCode     | 1.77.0       |

## IaC
The deployment uses [main.bicep](/iac/main.bicep) as its entry point, which in turn references the other Bicep files defined in the [modules](/iac/modules/) directory.

In addition to the Bicep files, there are configuration files in the [config](/iac/config/) directory and parameter files in the [parameters](/iac/parameters/) directory.  
The `.parameters.json` files contain template parameters, whereas the `.config.json` files store script variables.  
Each environment has its own set of configuration files that will apply only to that environment.

<br>

## Deployment script
The PowerShell script [deploy.ps1](/iac/deploy.ps1) is used both to validate the templates and to start an actual deployment.

<br>

In order to manually validate the templates, run the following commands:
```powershell
Set-Location iac/
./deploy.ps1 test -Validate
```

<br>

In order to manually start a deployment, run the following commands:
```powershell
Set-Location iac/
./deploy.ps1 test
```

<br>

While manual deployments are acceptable to the `test` environment, all deployments to `prod` should be run in the Azure DevOps pipeline.

<br>

## CI/CD
The Azure DevOps pipeline [azure-pipelines.yml](ci/azure-pipelines.yml) is configured to automatically trigger on pushes to the `main` branch.

The pipeline consists of an initial `Build` stage, which will validate the templates and run a what-if deployment.  
If the validation succeeds, the pipeline will continue to deploy the infrastructure to the `test` environment, followed by `prod`.

Approvals are configured for each environment, which means that the pipeline will pause and await an approval before continuing to the next stage.

Deployments to the `test` environment are allowed from any branch, whereas deployments to `prod` must be run from the `main` branch.

The required access to Azure is granted to the pipeline by means of Azure DevOps service connections created at the project-level.

<br>

In order to manually run the pipeline, go to:

[Azure DevOps](https://dev.azure.com/) → *Organization* → *Project* → Pipelines → *Pipeline* → Run pipeline → Run

<br>

## Branching strategy
Pushes directly to the `main` branch are blocked by policy.  
Instead, all changes should be implemented in feature branches and then merged into `main` using pull requests.