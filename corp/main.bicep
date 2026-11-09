
targetScope = 'resourceGroup'

@description('')
param location string

@description('')
param environment string

@description('')
param corpSpokeAddressPrefixes array

@description('')
param corpSpokeSubnetAddressPrefixes array

@description('')
param tenantId string

@description('')
param deployKeyVault bool

@description('')
param principalType string

@description('')
param deploystorgeAccount bool

@description('')
param deploylogAnalyticsWorkspace bool

@description('')
param deployActionGroup bool

@description('')
param deployServiceVault bool

// Corp VNet
module corpSpokeVnet '../modules/vnet.bicep' = {
  name: 'deploy-corp-spoke-vnet'
  params: {
    vnetName: 'vnet-corp-${environment}'
    location: location
    addressPrefixes: corpSpokeAddressPrefixes
    tags: {
      Environment: environment
      Purpose: 'Corp-Spoke'
    }
  }
}


// Corp Network Security Group
module corpSpokeNsg '../modules/nsg.bicep' = {
  name: 'deploy-corp-spoke-nsg'
  params: {
    nsgName: 'nsg-corp-${environment}'
    location: location
  }
}


// Corp Subnet with NSG association
module corpSpokeSubnet '../modules/subnet.bicep' = {
  name: 'deploy-corp-spoke-subnet'
  params: {
    vnetName: corpSpokeVnet.outputs.vnetName
    subnetName: 'snet-corp-${environment}'
    addressPrefix: corpSpokeSubnetAddressPrefixes[0]
    networkSecurityGroupId: corpSpokeNsg.outputs.nsgId
    routeTableId: corpSpokeRouteTable.outputs.routeTableId
  }
}


// Empty Corp Route Table
module corpSpokeRouteTable '../modules/rt.bicep' = {
  name: 'deploy-corp-spoke-route-table'
  params: {
    resourceName: 'rt-corp-${environment}'
    location: location
    disableBgpRoutePropagation: false

  }
}


// Corp Private DNS Zone
module corpSpokePrivateDnsZone '../modules/privateDNSZone.bicep' = {
  name: 'deploy-corp-spoke-private-dns-zone'
  params: {
    resourceName: 'privatedns-corp-${environment}'
    dnsLocation: 'global'
  }
}


// Corp Private DNS Zone Virtual Network Link
module dnsRecord '../modules/dnsRecord.bicep' = {
  name: 'deploy-dns-record'
  params: {
    zoneName: corpSpokePrivateDnsZone.outputs.privateDnsZoneName
    recordName: 'app1'
    ipv4Address: '203.0.113.1'
  }
}


// Corp Private DNS Zone Virtual Network Link
module privatenetworkLink '../modules/virtualNetworkLink.bicep' = {
  name: 'deploy-private-network-link'
  params: {
    resourceName: 'vnetlink-corp-${environment}'
    privateDnsZoneName: corpSpokePrivateDnsZone.outputs.privateDnsZoneName
    disableRegistration: false
    virtualNetworkName: corpSpokeVnet.outputs.vnetId
  }
}


// Managed Identity
module managedIdentity '../modules/managedIdentity.bicep' = {
  name: 'deploy-managed-identity'
  params: {
    location: location
    resourceName: 'corp-spoke-identity-${environment}'
  }
}


//Key vault
module keyVault '../modules/keyvault.bicep' = if (deployKeyVault){
  name: 'deploy-key-vault'
  params: {
    keyVaultName: 'kv-corp-${environment}-5108'
    location: location
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    tenantId: tenantId
    skuName: 'standard'
    disableRbacAuthorization: false
    disableSoftDelete: false
    softDeleteRetentionInDays: 90
    disablepurgeProtection: true
    skuFamily: 'A'
    accessPolicies: []
  }
}


// Role Assignment for Managed Identity to Key Vault
module roleAssignment '../modules/roleAssignment.bicep' = if (deployKeyVault){
  name: 'assign-role-to-key-vault'
  params: {
    principalType: principalType
    principalId: managedIdentity.outputs.identityPrincipalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6') // Key Vault Secrets User Role Definition ID
  }
}


// storageAccount 
module storageAccount '../modules/storageAccount.bicep' = if (deploystorgeAccount){
name : 'deploy-storge-account'
params :{
  resourceName : 'sa-corp-${environment}'
  location : location
  skuName : 'Standard_LRS'
  skuKind : 'StorageV2'
  accessTier : 'Hot'
  allowBlobPublicAccess : false
  allowCrossTenantReplication : false
  allowSharedKeyAccess : false
  defaultToAuthentication : true
  isHnsEnabld :false
  isNfsV3Enabled :false
  isSftpEnabled : false
  publicNetworkAccess : 'enabled'
  supportsHttpsTrafficOnly :true
  }

}


//storage container
module storageContainer '../modules/storageContainer.bicep' = if (deploystorgeAccount){
  name : 'deploy-storage-container'
  
  params:{
    location:location
    resourceName: 'sc-corp-${environment}'
    storageAccountName: storageAccount.outputs.storageAccountName

  }
}


//logAnalyticsWorkspace
module logAnalyticsWorkspace '../modules/logAnalyticsWorkspace.bicep' = if (deploylogAnalyticsWorkspace){
  name : 'deploy-workspace'

  params:{
    
    resourceName:'la-corp-${environment}'
    location:location
    disableLocalAuth: true
    enableLogAccessUsingOnlyResourcePermissions: true
    publicNetworkAccessForIngestion:'enabled'
    publicNetworkAccessForQuery:'enabled'
    retentionDays:30
    skuName:'PerGB2018'
  
  }
}


//actionGroup
module actionGroup '../modules/actionGroup.bicep' = if (deployActionGroup){
  name : 'deploy-action-group'

  params:{
    location : location
    resourceName :'ag-corp-${environment}'
    armRoleReceivers : []
    automationRunbookReceivers : []
    azureAppPushReceivers : []
    azureFunctionReceivers : []
    emailReceivers :[
      {
         emailAddress: 'keivan.tahery@gmail.com'
         name: 'test'

      }
    ]
    isActionGroupEnabled : true
    eventHubReceivers : []
    actionGroupShortName  : 'ag-corp'
    itsmReceivers :[]
    logicAppReceivers :[]
    smsReceivers :[]
    voiceReceivers :[]
    webhookReceivers :[]
      
  }
}


//recoveryServiceVault
module serviceVault '../modules/recoveryServiceVault.bicep' = if (deployServiceVault){
  name : 'deploy-serviceVault-name'
  params:{
    location: location
    resourceName: 'rsv-corp-${environment}'
    publicNetworkAccess: 'enabled'
    skuName: 'Standard'
  }
}

// Outputs
output corpSpokeVnetId string = corpSpokeVnet.outputs.vnetId
output corpSpokeSubnetId string = corpSpokeSubnet.outputs.subnetId
output corpSpokeNsgId string = corpSpokeNsg.outputs.nsgId
output keyVaultId string = keyVault.outputs.keyVaultId
output managedIdentityId string = managedIdentity.outputs.identityId
output corpSpokePrivateDnsZoneId string = corpSpokePrivateDnsZone.outputs.privateDnsZoneId
output storageAccountId string  = storageAccount.outputs.storageAccountId
output storageAccountName string  = storageAccount.outputs.storageAccountName
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.outputs.workspaceName
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.workspaceId
