@description('  The name of the storage account to be created.')
param resourceName string

@description('The location of the storage account.')
param location string

@description('The name of the SKU for the storage account.')
param skuName string

@description('The kind of the SKU for the storage account.')
param skuKind string

@description('The access tier for the storage account.')
param accessTier string

@description('Specifies whether blob public access is allowed.')
param allowBlobPublicAccess bool

@description('Specifies whether cross-tenant replication is allowed.')
param allowCrossTenantReplication bool

@description('Specifies whether shared key access is allowed. If false, only Azure Active Directory authentication is allowed.')
param allowSharedKeyAccess bool

@description('Specifies whether to default to OAuth authentication. If true, the storage account will default to OAuth authentication for all requests. If false, the storage account will default to shared key authentication for all requests.')
param defaultToAuthentication bool

@description('Specifies whether Hierarchical Namespaces is enabled. If true, the storage account will have a hierarchical namespace and support for Azure Data Lake Storage Gen2 features. If false, the storage account will not have a hierarchical namespace and will not support Azure Data Lake Storage Gen2 features.')
param isHnsEnabld bool

@description('Specifies whether NFS v3 is enabled. If true, the storage account will support NFS v3 protocol for file shares. If false, the storage account will not support NFS v3 protocol for file shares.')
param isNfsV3Enabled bool

@description('Specifies whether SFTP is enabled. If true, the storage account will support SFTP protocol for file shares. If false, the storage account will not support SFTP protocol for file shares.')
param isSftpEnabled bool

@description('Specifies whether public network access is enabled. If true, the storage account will allow access from public networks. If false, the storage account will only allow access from private networks.')
param publicNetworkAccess string

@description('Specifies whether the storage account supports HTTPS traffic only. If true, the storage account will only allow HTTPS traffic. If false, the storage account will allow both HTTP and HTTPS traffic.')
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


