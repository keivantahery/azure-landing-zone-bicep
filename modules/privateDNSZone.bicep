
@description('The name of the private DNS zone to be created.')
param resourceName string

@description('The location of the private DNS zone.')
param dnsLocation string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: '${resourceName}.com'
  location: dnsLocation
}

output privateDnsZoneId string = privateDnsZone.id
output privateDnsZoneName string = privateDnsZone.name
