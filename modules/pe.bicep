
@description('The name of the Private Endpoint.')
param resourceName string

@description('The location for the Private Endpoint.')
param location string

@description('The subnet for the Private Endpoint.')
param subnet object

@description('The group IDs for the Private Link Service connection.')
param groupIds array

@description('The ID of the Private Link Service to connect to the Private Endpoint.')
param privateLinkServiceId string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: resourceName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${resourceName}-connection'
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: groupIds
        }
      }
    ]
    subnet: {
      id: subnet.id
    }
  }
}

output privateEndpointId string = privateEndpoint.id
