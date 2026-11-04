param location string
param resourceName string

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: resourceName
  location: location
}

output identityId string = userAssignedIdentity.id
output identityPrincipalId string = userAssignedIdentity.properties.principalId
