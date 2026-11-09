@description('')
param resourceName string

@description('')
param location string

@description('')
param skuName string

@description('')
param skuKind string

@description('')
param accessTier string

@description('')
param allowBlobPublicAccess bool

@description('')
param allowCrossTenantReplication bool

@description('')
param allowSharedKeyAccess bool

@description('')
param defaultToAuthentication bool

@description('')
param isHnsEnabld bool

@description('')
param isNfsV3Enabled bool

@description('')
param isSftpEnabled bool

@description('')
param publicNetworkAccess string

@description('')
param supportsHttpsTrafficOnly bool



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: resourceName
  location: location
  sku: {
    name: skuName
  }
  kind: skuKind
  properties: {
    accessTier:accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    allowCrossTenantReplication: allowCrossTenantReplication
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: defaultToAuthentication
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        queue: {
          keyType: 'Service'
        }
        table: {
          keyType: 'Service'
        }
      }
    }
    isHnsEnabled: isHnsEnabld
    isNfsV3Enabled: isNfsV3Enabled
    isSftpEnabled: isSftpEnabled
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: 'Allow'
    }
    publicNetworkAccess: publicNetworkAccess
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name


