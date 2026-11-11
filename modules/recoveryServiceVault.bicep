@description('The name of the Recovery Services vault to be created.')
param resourceName string

@description('The location of the Recovery Services vault.')
param location string

@description('Specifies whether public network access is enabled for the Recovery Services vault.')
param publicNetworkAccess string

@description('The name of the SKU for the Recovery Services vault.')
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
