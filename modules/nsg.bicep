
@description('The name of the network security group to be created.')
param nsgName string

@description('The location of the network security group.')
param location string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: []
  }
}

output nsgId string = networkSecurityGroup.id
output nsgName string = networkSecurityGroup.name

