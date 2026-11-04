param nsgName string
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

