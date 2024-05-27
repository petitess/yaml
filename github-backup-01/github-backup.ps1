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


if ($false) {

    $URL = "https://api.github.com/repos/petitess/bicep/zipball/main"
    $headers = @{
        ##"Authorization"        = "Bearer $GITHUB_TOKEN"
        "X-GitHub-Api-Version" = "2022-11-28"
        "Accept"               = "application/vnd.github.v3.raw"
    }


    $I = (Invoke-RestMethod -Method GET -URI $URL -Headers $headers) 
    $I > file.zip
}


wget --header="Accept:application/vnd.github.v3.raw" -O - "https://api.github.com/repos/petitess/bicep/zipball/main" | tar xz


get-command *archive*

invoke


Invoke-WebRequest -uri "https://api.github.com/repos/petitess/bicep/zipball/main" -Method "GET"  -Outfile (-join("fdfd",".zip"))  
