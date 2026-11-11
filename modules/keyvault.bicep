@description('Specifies the name of the key vault.')
param keyVaultName string

@description('Specifies the Azure location where the key vault should be created.')
param location string

@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.')
param enabledForDeployment bool

@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
param enabledForDiskEncryption bool

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.')
param tenantId string

@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string

@description('Specifies whether to disable RBAC authorization for the key vault.')
param disableRbacAuthorization bool

@description('Specifies whether the soft delete functionality is enabled for the key vault. If true, the key vault and its objects can be recovered after deletion. If false, the key vault and its objects are permanently deleted when deleted.')
param disableSoftDelete bool

@description('Specifies the number of days that the key vault and its objects are retained after deletion, if soft delete is enabled. The minimum retention period is 7 days and the maximum retention period is 90 days.')
param softDeleteRetentionInDays int

@description('Specifies whether purge protection is enabled for the key vault. If true, the key vault and its objects cannot be permanently deleted until the retention period has passed. If false, the key vault and its objects can be permanently deleted immediately after deletion.')
param disablepurgeProtection bool

@description('Specifies the SKU family for the key vault. The only valid value is "A" for the Azure Key Vault service.')
param skuFamily string

@description('Specifies the access policies for the key vault. Each access policy defines the permissions granted to a specific security principal (user, group, or application) for the key vault and its objects.')
param accessPolicies array


resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enableRbacAuthorization:disableRbacAuthorization
    tenantId: tenantId
    enableSoftDelete: disableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enablePurgeProtection: disablepurgeProtection
    sku: {
      name: skuName
      family: skuFamily
    }
    accessPolicies: accessPolicies
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

output keyVaultId string = kv.id
output keyVaultName string = kv.name
