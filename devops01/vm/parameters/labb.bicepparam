using '../main.bicep'

param param = {
  location: 'SwedenCentral'
  locationAlt: 'WestEurope'
  prefix: 'bicep-demo'
  tags: {
    Application: 'Infra'
    Environment: 'Labb'
  }
  vm: [
    {
      name: 'vmmgmtprod01'
      availabilitySetName: ''
      tags: {
        Application: 'Management'
        Service: 'Management'
        UpdateManagement: 'Critical_Monthly_GroupB'
        Autoshutdown: 'No'
      }
      vmSize: 'Standard_B2ms'
      plan: {}
      imageReference: {
        publisher: 'microsoftwindowsserver'
        offer: 'windowsserver'
        sku: '2022-datacenter'
        version: 'latest'
      }
      osDiskSizeGB: 128
      dataDisks: []
      networkInterfaces: [
        {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.10.5.11'
          primary: true
          subnet: 'snet-mgmt-prod-01'
          publicIPAddress: false
          enableIPForwarding: false
          enableAcceleratedNetworking: false
        }
      ]
      backup: {
        enabled: true
      }
      monitor: {
        alert: true
        enabled: true
      }
      extensions: true
    }
  ]
}
