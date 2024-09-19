## GIT - Dev to Uat
#### 1.Run only the first time (before running prereq)
```s
git clone https://github.com/ORG/azure-application-uta-westeurope.git
cd azure-application-uta-westeurope
git remote add upstream https://github.com/ORG/azure-application-dev-westeurope.git
git pull upsteam main
git config merge.ours.driver true
git checkout main
git checkout upstream/main -- .gitattributes
git commit -m "Added .gitattributes"
git push
```
#### 2.Run each time
```s
git checkout main
git pull --prune
#### Remove
git branch -D release/qua
git fetch upstream
git diff main upstream/main -- ':!/.github/address_spaces.txt' ':!/.github/workflows/context.json'
git checkout -b release/qua
git merge upstream/main --allow-unrelated-histories --strategy-option theirs 
git push --set-upstream origin release/qua
```
#### 3.Run pipeline on release/qua branch - only plan
#### 4.Create a pull request into main
#### 5.Run pipeline on main branch

```mermaid
%%{init: { 'theme': 'base', 'gitGraph': { 'mainBranchName': 'main (prod)', 'showCommitLabel': false}} }%%

gitGraph
       branch "main (qua)" order: 7
       branch "main (dev)" order: 9
       commit
       branch "feature/XXX" order: 10
       commit
       checkout "main (dev)"
       merge "feature/XXX" tag:"PR"
       checkout "main (qua)"
       commit
       branch release/qua order: 8
       merge "main (dev)"
       checkout "main (qua)"
       merge release/qua tag:"PR"
       checkout "main (prod)"
       commit
       branch release/prod order: 6
       merge "main (qua)"
       checkout "main (prod)"
       merge release/prod tag:"PR"

```
