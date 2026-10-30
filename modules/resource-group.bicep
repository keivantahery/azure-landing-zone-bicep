
targetScope = 'subscription'

@description('Name of the resource group')
param resourceGroupName string

@description('Azure deployment location')
param location string

@description('Resource tags')
param tags object = {}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

output resourceGroupId string = resourceGroup.id
