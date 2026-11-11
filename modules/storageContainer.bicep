
@description('Name of the storage container.')
param resourceName string

@description('Name of the existing storage account.')
param storageAccountName string

@description('Public access level for the container.')
@allowed([
  'None'
  'Blob'
  'Container'
])
param publicAccess string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageAccountName
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' existing = {
  parent: storageAccount
  name: 'default'
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: blobService
  name: resourceName
  properties: {
    publicAccess: publicAccess
  }
}

output storageContainerId string = storageContainer.id
