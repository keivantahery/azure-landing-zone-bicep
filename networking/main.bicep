
targetScope = 'resourceGroup'

param location string
param environment string
param hubAddressPrefixes array
param hubSubnetPrefix string

module hubVnet '../modules/vnet.bicep' = {
  name: 'deploy-hub-vnet'
  params: {
    vnetName: 'vnet-hub-${environment}'
    location: location
    addressPrefixes: hubAddressPrefixes
    tags: {
      Environment: environment
      Purpose: 'Hub-Network'
    }
  }
}



module sharedSubnet '../modules/subnet.bicep' = {
  name: 'deploy-shared-subnet'
  params: {
    vnetName: hubVnet.outputs.vnetName
    subnetName: 'snet-shared-${environment}'
    addressPrefix: hubSubnetPrefix
    networkSecurityGroupId: ''
    routeTableId: ''
  }
}

output hubVnetId string = hubVnet.outputs.vnetId

output hubSubnetId string = sharedSubnet.outputs.subnetId
