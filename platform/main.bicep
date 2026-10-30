
targetScope = 'subscription'

param location string
param environment string

module managementRg '../modules/resource-group.bicep' = {
  name: 'deploy-management-rg'
  params: {
    resourceGroupName: 'rg-management-${environment}'
    location: location
    tags: {
      Environment: environment
      Purpose: 'Management'
    }
  }
}

output managementResourceGroupId string = managementRg.outputs.resourceGroupId
