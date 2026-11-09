@description('')
param resourceName string

@description('')
param location string

@description('')
param publicNetworkAccess string

@description('')
param skuName string


resource vault 'Microsoft.RecoveryServices/vaults@2022-10-01' = {
  name: resourceName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
}

output vaultId string = vault.id
output vaultName string = vault.name
