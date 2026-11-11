
targetScope = 'resourceGroup'

@description('The principal ID of the user, group, or service principal to assign the role to.')
param principalId string

@description('The type of the principal.')
param principalType string

@description('The ID of the role definition to assign.')
param roleDefinitionId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, roleDefinitionId)
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: roleDefinitionId
  }
}

output roleAssignmentId string = roleAssignment.id
