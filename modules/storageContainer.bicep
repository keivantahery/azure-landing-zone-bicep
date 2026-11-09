param location string
param resourceName string
param storageAccountName string



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name : storageAccountName
}

resource storageContainer 'Microsoft.Discovery/storageContainers@2026-06-01' = {
  location: location
  name: resourceName
  properties: {
    storageStore: {
      kind: 'string'
      // For remaining properties, see StorageStore objects
    }
  }
  
}
