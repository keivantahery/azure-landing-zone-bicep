
@description('Existing VNet name')
param vnetName string

@description('Subnet name')
param subnetName string

@description('Subnet address prefix')
param addressPrefix string

param networkSecurityGroupId string
param routeTableId string 


resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: !empty(networkSecurityGroupId) ?{
      id: networkSecurityGroupId
    } : null
    routeTable: !empty(routeTableId) ? {
      id: routeTableId
    } : null
  }
}

output subnetId string = subnet.id


