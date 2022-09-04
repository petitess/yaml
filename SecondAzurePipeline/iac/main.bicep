targetScope = 'subscription'

param config object
param virtualNetwork object

var location = config.location.name
var tags = {
  Company: config.company.name
  Environment: config.environment.name
}
var affix = {
  environment: toLower('${config.environment.affix}')
  environmentLocation: toLower('${config.environment.affix}-${config.location.affix}')
  environmentLocationAlt: toLower('${config.environment.affix}-${config.location.alt.affix}')
  environmentCompany: toLower('${config.environment.affix}-${config.company.affix}')
  environmentCompanyStripped: toLower('${config.environment.affix}${config.company.affix}')
}

resource rgInfra 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: toLower('rg-infra-${affix.environmentLocation}-01')
  location: location
  tags: union(tags, {
      Application: 'Infrastructure'
    })
}

module vnet 'modules/vnet.bicep' = {
  scope: rgInfra
  name: 'module-${affix.environment}-vnet'
  params: {
    addressPrefixes: virtualNetwork.addressPrefixes
    dnsServers: virtualNetwork.dnsServers
    location: rgInfra.location
    name: 'vnet-${affix.environmentLocation}-01'
    peerings: virtualNetwork.peerings
    //routeTable: virtualNetwork.routeTable
    natGateway: virtualNetwork.natGateway
    subnets: virtualNetwork.subnets
  }
}

resource rgBackup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: toLower('rg-backup-${affix.environmentLocation}-01')
  location: location
  tags: union(tags, {
      Application: 'Backup'
    })
}
