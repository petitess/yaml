targetScope = 'subscription'

param param object
param timestamp string = utcNow('dd/MM/yyyy_HH:mm')
var affix = toLower('${param.tags.Application}-${param.tags.Environment}')
var env = toLower(param.tags.Environment)

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${param.prefix}-${env}-01'
  location: param.location
  tags: union(param.tags, {
      T: timestamp
    })
}

module vnet 'modules/vnet.bicep' = {
  scope: rg
  name: 'module-${affix}-vnet'
  params: {
    addressPrefixes: param.vnet.addressPrefixes
    dnsServers: param.vnet.dnsServers
    location: param.location
    name: 'vnet-${affix}-01'
    natGateway: param.vnet.natGateway
    peerings: param.vnet.peerings
    subnets: param.vnet.subnets
  }
}

module bas 'modules/bas.bicep' = if (false) {
  scope: rg
  name: 'module-${affix}-bas'
  params: {
    location: param.location
    name: 'bas-${vnet.outputs.name}'
    vnetName: vnet.outputs.name
  }
}
