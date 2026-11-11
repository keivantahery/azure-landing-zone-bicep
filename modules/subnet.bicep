
@description('Existing VNet name')
param vnetName string

@description('Subnet name')
param subnetName string

@description('Subnet address prefix')
param addressPrefix string

@description('Network Security Group ID to associate with the subnet. Leave empty if not needed.')
param networkSecurityGroupId string

@description('Route Table ID to associate with the subnet. Leave empty if not needed.')
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


