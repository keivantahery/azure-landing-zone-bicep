
@description('Virtual network name')
param vnetName string

@description('Azure region')
param location string

@description('VNet address prefixes')
param addressPrefixes array

@description('Resource tags')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
  }
}






output vnetId string = vnet.id
output vnetName string = vnet.name
