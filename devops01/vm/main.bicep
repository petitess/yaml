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

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: 'vnet-${affix}-01'
  scope: resourceGroup('rg-${param.prefix}-${env}-01')
}

resource rgVm 'Microsoft.Resources/resourceGroups@2022-09-01' = [for vm in param.vm: {
  name: toLower('rg-${vm.name}')
  location: param.location
  tags: union(vm.tags, {
      Application: vm.tags.Application
      Environment: param.tags.Environment
    })
}]

module vm 'modules/vm.bicep' = [for (vm, i) in param.vm: if (true) {
  scope: rgVm[i]
  name: 'module-${vm.name}-vm'
  params: {
    availabilitySetName: vm.availabilitySetName
    computerName: contains(vm, 'computerName') ? vm.computerName : vm.name
    dataDisks: vm.dataDisks
    imageReference: vm.imageReference
    location: rgVm[i].location
    name: vm.name
    networkInterfaces: vm.networkInterfaces
    osDiskSizeGB: vm.osDiskSizeGB
    plan: vm.plan
    tags: union(rgVm[i].tags, vm.tags)
    vmSize: vm.vmSize
    vnetname: vnet.name
    vnetrg: rg.name
  }
}]
