param (
    [Parameter(Mandatory)]
    [String]$GITHUB_TOKEN

    # [ValidateSet('validate', 'what-if', 'create')]
    # [String]$Command = 'create'
)


$Token
$Org = "petitess"


$URL = "https://api.github.com/repositories"
$headers = @{
    "Authorization"        = "Bearer $GITHUB_TOKEN"
    "X-GitHub-Api-Version" = "2022-11-28"
    "Accept"               = "application/vnd.github+json"
}
$I = (Invoke-RestMethod -Method GET -URI $URL -Headers $headers) | ConvertTo-Json
$I