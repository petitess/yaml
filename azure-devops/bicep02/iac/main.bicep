targetScope = 'subscription'

param config object
var location = config.location.name

resource rg01 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-infra'
  location: location
}
