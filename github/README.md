#### Setup github runner
```bash
export http_proxy='http://proxy.my-proxy.net:8080'
export https_proxy='http://proxy.my-proxy.net:8080'
cd /
sudo mkdir actions-runner
sudo chmod -R 777 /actions-runner
cd actions-runner
curl -x http://proxy.my-proxy.net:8080 -o actions-runner-linux-x64-2.323.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-x64-2.323.0.tar.gz
sudo tar xzf ./actions-runner-linux-x64-2.323.0.tar.gz
sudo chmod -R 777 /actions-runner
./config.sh --url https://github.com/01-APPLICATIONS/abcd-analytics-common-infra --token XYZ --unattended --name abcd-linux-prd --runasservice --work /tmp/_work_common-infa --runnergroup Default --labels abcd-linux-prd
sudo ./svc.sh install
sudo ./svc.sh start
echo 'export https_proxy="http://proxy.my-proxy.net:8080"' >> ~/.bashrc
```
#### Configure proxy on the runner service
```bash
sudo nano /etc/systemd/system/actions.runner.<org>-<repo>.<runner>.service
 
[Service]
Environment="HTTP_PROXY=http://proxy.my-proxy.net:8080"
Environment="HTTPS_PROXY=http://proxy.my-proxy.net:8080"
Environment="NO_PROXY=localhost,127.0.0.1,::1"
 
sudo systemctl daemon-reexec
sudo systemctl restart actions.runner.<org>-<repo>.<runner>
```
