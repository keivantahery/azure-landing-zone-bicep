param resourceName string
param privateDnsZoneName string
param disableRegistration bool = false
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
