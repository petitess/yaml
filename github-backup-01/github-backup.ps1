$Token
$Org = "petitess"


$URL = "https://api.github.com/orgs/$Org/repos"
$headers = @{
    "Authorization"        = "Bearer $Token"
    "Content-type"         = "application/json"
    "X-GitHub-Api-Version" = "2022-11-28"
}
$I = (Invoke-RestMethod -Method GET -URI $URL -Headers $headers) | ConvertTo-Json
$I