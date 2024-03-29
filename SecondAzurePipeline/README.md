<br>

## Getting started
This project is developed cross-platform and can be managed and deployed from `Windows`, `Linux` and `Mac`.  
In addition, it can very easily be integrated into a CI/CD tool, such as `Azure Pipelines`.

<br>

### Prerequisites
In order to deploy this project you will need an account that is assigned the directory roles `Application Administrator`, `Privileged Role Administrator` and `User Administrator` in the `Azure AD` tenant and also the Azure role `Owner` on the subscriptions in use.

There are also a number of prerequisites that need to be installed on your local machine before you can succesfully manage and deploy this project.  
Simply follow the instructions below for the operating system in use.

<br>

### `Windows`

#### 1. Install `Git`, `Visual Studio Code`, `Bicep`, and the latest version of `PowerShell Core` by running the following cmdlets in an elevated `PowerShell` prompt:
```powershell
winget install Git.Git
winget install Microsoft.VisualStudioCode
winget install Microsoft.PowerShell
winget install Microsoft.Bicep
```

<br>

#### 2. Install the following `Azure modules` and `Visual Studio Code extensions` in the `Powershell` prompt:

The Azure modules:
```powershell
Install-Module Az
Install-Module AzureAD
Install-Module Microsoft.Graph
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
#### 2. Get the Git Clone URL from `Azure DevOps`:
[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> \<repo-name\> -> Clone -> Copy clone URL to clipboard
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

<br>

# Build and Test
## Compatible versions

The following software versions have been tested and verified to be compatible with this project:

| Software        | Version      |
| --------------- | ------------ |
| Windows         | 10 (21H1)    |
| Linux           | Ubuntu 20.04 |
| macOS           | 11.3.1       |
| Powershell      | 7.2.1        |
| az              | 7.0.0        |
| Microsoft.Graph | 1.9.1        |
| git             | 2.33.1       |
| Homebrew        | 3.1.9        |
| VSCode          | 1.63.2       |

<br>

## Deployment

### 1. Environment files
The JSON files in the directory [environments](/environments/) are used to centrally store both shell script variables and template parameters.  
Update all values as required prior to deploying.

If you want to add more environments than `test` and `prod`, simply duplicate an existing environment file and rename it accordingly.  
The name of the environment should be lower-case only and cannot contain any spaces or special characters.

<br>

### 2. First-time deployment

The script `.managedIdentity.ps1` in the directory [dev/InitScripts](/dev/InitScripts) needs to be deployed manually to be able to deploy the rest of the repo. The script requires you to login to microsoft.graph (once) and once for each environment. This is so you can create a resouceGroup and a managed Identity for each environment. Use the following syntax to run the script:

```powershell
./dev/InitScripts/managedIdentity.ps1 
```

The initial deployment of this project needs to be run manually, before it can actually be integrated into a CI/CD tool, such as `Azure Pipelines`.  

A manual deployment is triggered by running the shell script `deploy.ps1` in the directory [iac](/iac/), using the following syntax:

```powershell
./iac/deploy.ps1 <environment>
```

<br>

### 3. CI/CD
Now that the environment has been deployed manually, it's possible to integrate this project into a CI/CD tool, such as `Azure Pipelines`.

The YAML file `azure-pipelines.yml` in the directory [ci](/ci/) contains a CI/CD pipeline with stages for the environments `test` and `prod`.  
If you want to add more stages than `test` and `prod`, simply duplicate the code block for an existing stage and replace the values accordingly.  
Make sure to put the new code block in the desired deploy order, as the stages naturally will run in sequence from top to bottom.

Then follow the below steps to add the pipeline to `Azure Pipelines`:

[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Pipelines -> Create Pipeline -> Azure Repos Git -> \<repo-name\> -> Save

<br>

The embedded `Azure Pipelines` status badge at the top of `README.md` is statically referencing the repository `Xxx-Governance`:

To avoid confusion and instead show the status of the current repository's pipeline, replace the current code on line 1 with code specific to your pipeline:

[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Pipelines -> \<pipeline-name\> -> More... -> Status badge -> Sample markdown

<br>

### 4. Service Principal
In order for the CI/CD pipeline to run successfully, a service principal must first be created in `Azure AD` on the `Tenant Root Group` scope.
In addition, this service principal needs to be assigned the directory role `User Administrator` in the `Azure AD` tenant and also the Azure role `Owner` on the applicable management group. There are a few steps that needs to be done to create a service principal:

#### 1. Access to root management group
In order to get access on the root management group go to the `Azure portal`.

Then you go to `Azure Active Directory` and click `Properties`.

Under `Access management for Azure resources` you change it to `Yes` 

#### 2. Create the service principal by going to service connection in DevOps

URL: [Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> \<_Settings\> -> \<adminservices\>

or

Manually: [Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> \<Project settings\> -> \<Service connections\>

Click on `New service connection` -> `Azure Resource Manager` -> `Service principal (automatic)` and choose `Management Group` as Scope level.

Choose the `Tenant Root Group` and the name of the Service connection. Then click Save.

#### 3. Turn off `Access management for Azure resources`

Go back and do step 1 again but change `Access management for Azure resources` to `No`

<br>

### 5. Pipeline deployment

The CI/CD pipeline defined in `azure-pipelines.yml` is configured to trigger on the Git branch `main`, meaning that a deployment will start as soon as a new commit is pushed there.  
To avoid unnecessary deployments, there are certain files that are excluded from triggering the pipeline, for example `README.md`.

As expected, the stages defined in the CI/CD pipeline are deployed sequentially, meaning that if a previous stage fails, the remaining stages will not run.

<br>

### 6. Branch policies

Since every push to `main` will trigger the pipeline, it is highly recommended to configure a branch policy that blocks direct pushes to the `main` branch.  
Instead, all changes should be made in short-lived feature branches. A pull request is then created to merge the changes into the `main` branch, which in turn will trigger a deployment. Once the merge is complete, the feature branch in question is removed from the repository.

<br>

To configure a branch policy at the repository level, go to:

[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> Branches

Click the `More...` icon on `main` and select `Branch policies`.

Tick the checkbox `Require a minimum number of reviewers` and enter the desired minimum number of reviewers.

In order to keep the commit history linear and more legible, it's also a good practice to limit the allowed merge types to `Squash merge` only, meaning that all commits from the source branch will be consolidated into a single commit in `main`, as opposed to individual commits.  
This is done by simply ticking the checkbox `Limit merge types` and then make sure to only tick the checkbox `Squash merge`.

<br>

To configure a branch policy at the project level, go to:

[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Project settings -> Repositories -> Policies

Click the `Add branch protection across all repositories` icon, select `Protect the default branch of each repository` and click `Create`.

Tick the checkbox `Require a minimum number of reviewers` and enter the desired minimum number of reviewers.

In order to keep the commit history linear and more legible, it's also a good practice to limit the allowed merge types to `Squash merge` only, meaning that all commits from the source branch will be consolidated into a single commit in `main`, as opposed to individual commits.  
This is done by simply ticking the checkbox `Limit merge types` and then make sure to only tick the checkbox `Squash merge`.

<br>

### 7. Feature branches

Since direct pushes to `main` are now blocked, all consequent changes to this repository need to be made in separate feature branches.  
It's advisable to prefix the names of all feature branches with the string `feature/`, as this will in fact show as a directory in `Azure Repos`.  
Also, avoid using spaces and special characters in the branch name.

In order to create and check out a new feature branch based on `main`, run the following commands:
```shell
git checkout main

git pull

git checkout -b <branch-name>
```

Once the desired changes have been made in the new branch, push a commit to `origin` by running the following commands:
```shell
git status

git add .

git commit --message "<message>"

git push --set-upstream origin <branch-name>

git log
```

<br>

### 8. Pull requests

The remaining step to actually trigger a deployment is to merge the feature branch into `main`, which is done by creating a new pull request in `Azure DevOps`:

[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> Pull requests -> New pull request

- Select your feature branch as the source and the `main` branch as the destination.  
- Under `Reviewers`, add the appropriate people to review and approve the pull request.
- Click `Create`.

<br>

In order to approve a pull request, follow these steps:

[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> Pull requests -> Active

- Click on the pull request in question.
- Click `Approve`.
- Click `Complete`, change `Merge type` to "Squash commit" and click `Complete merge`.
- Remove the feature branch locally by running:
```shell
git checkout main

git branch --delete <branch-name>

git pull --prune
```

<br>

If you ever need to revert the changes introduced in a pull request, follow these steps:

[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Repos -> Pull requests -> Completed

- Click on the pull request in question.
- Click `Revert` twice.
- Click `Create Pull Request` and follow the previous instructions on how to create and approve a pull request.

<br>

### 9. Environment approvals

To improve traceability and require approval between stages, the pipeline is configured with deployment jobs that reference the environment in question.  
In order to require approval for deployments to the `prod` environment, follow these steps:

[Azure DevOps](https://dev.azure.com/) -> \<org-name\> -> \<project-name\> -> Pipelines -> Environments -> prod -> More... -> Approvals and checks

Click the `Add check` icon, select `Approvals` and click `Next`.

Add the desired approvers, click `Advanced`, untick the checkbox `Allow approvers to approve their own runs` and click `Create`.

<br>

## Fork this project:

If you want to fork this project to a new repository, run the following code blocks one by one:
```shell
read -p "Name of source repository: " srcRepo
```

```shell
read -p "Source Git reference (branch, tag or commit ID): " srcGitRef
```

```shell
read -p "Name of destination repository: " dstRepo
```

```shell
read -p "Git Clone URL for destination repository: " cloneUrl
```

```shell
path=~/repos

cd "${path}/${srcRepo}"

git pull --all

git checkout "${srcGitRef}"

mkdir -p "${path}/${dstRepo}"

cp -r "${path}/${srcRepo}/" "${path}/${dstRepo}"

git checkout -

cd "${path}/${dstRepo}"

rm -rf .git

git init

git add .

git commit --message "${srcRepo} - ${srcGitRef}"

git remote add origin "${cloneUrl}"

git push --set-upstream origin main
```

<br>

# Merge with another repository:

If you want to merge another repository into this project, run the following code blocks one by one:
```shell
read -p "Name of source repository: " srcRepo
```

```shell
read -p "Source Git reference (branch, tag or commit ID): " srcGitRef
```

```shell
read -p "Git Clone URL for source repository: " cloneUrl
```

```shell
read -p "Name of destination repository: " dstRepo
```

```shell
read -p "Destination Git reference (branch, tag or commit ID): " dstGitRef
```

```shell
path=~/repos

cd "${path}/${dstRepo}"

git remote add upstream "${cloneUrl}"

git pull --all

git checkout "${dstGitRef}"

git checkout -b "${srcRepo}/${srcGitRef}"

git merge "${srcGitRef}" --squash --no-commit --allow-unrelated-histories --message "${srcRepo} - ${srcGitRef}"

git status

# If there are any merge conflicts, resolve these before continuing.
```

```shell
a="$(git ls-tree -r --name-only "${srcGitRef}" | sort)"

b="$(find . -type f | sed 's#^\./##' | grep -E -v -- '.git/|.DS_Store' | sort)"

diff <(echo "$a") <(echo "$b")
```

```shell
git diff "${dstGitRef}"
```

```shell
git add .

git commit --message "${srcRepo} - ${srcGitRef}"

git push --set-upstream origin "${srcRepo}/${srcGitRef}"

git remote remove upstream

# Create a new pull request to merge into main
```

<br>

## Versioning:
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).  
For a list of all released versions, please see our [changelog](/CHANGELOG.md).

In order to keep track of all released versions in Git, we're using annotated tags with names made up of the semantic version prefixed with the letter "v", for example:  
`v1.0.0`

To tag the latest commit in `main` as a new release and then push it to `origin`, run the following commands:
```shell
git checkout main

git tag --annotate "v<semantic-version>" --message "Release version <semantic-version>"

git push --follow-tags
```

<br>


<!-- This README is based on the following template: https://github.com/PurpleBooth/a-good-readme-template -->