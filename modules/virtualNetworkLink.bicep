
@description('Specifies the name of the virtual network link.')
param resourceName string

@description('Specifies the name of the private DNS zone.')
param privateDnsZoneName string

@description('Specifies whether registration is disabled.')
param disableRegistration bool = false

@description('Specifies the name of the virtual network.')
param virtualNetworkName string



resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' existing = {
  name: privateDnsZoneName
}

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: resourceName
  location: 'global'
  parent: privateDnsZone
  properties: {
    registrationEnabled: disableRegistration
    virtualNetwork: {
      id: virtualNetworkName
    }
  }
}

output virtualNetworkLinkId string = virtualNetworkLink.id
