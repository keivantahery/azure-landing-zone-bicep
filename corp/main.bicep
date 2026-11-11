
targetScope = 'resourceGroup'

@description('The location of the resource.')
param location string

@description('The environment for the deployment.')
param environment string

@description('The address prefixes for the Corp Spoke VNet.')
param corpSpokeAddressPrefixes array

@description('The address prefixes for the Corp Spoke Subnets.')
param corpSpokeSubnetAddressPrefixes array

@description('The tenant ID for the deployment.')
param tenantId string

@description('Specifies whether to deploy the Key Vault. If true, the Key Vault will be deployed. If false, the Key Vault will not be deployed.')
param deployKeyVault bool

@description('Specifies whether to deploy the Route Table. If true, the Route Table will be deployed. If false, the Route Table will not be deployed.')
param deployRouteTable bool

@description('The type of the principal for role assignment.')
param principalType string

@description('Specifies whether to deploy the Storage Account. If true, the Storage Account will be deployed. If false, the Storage Account will not be deployed.')
param deploystorgeAccount bool

@description('Specifies whether to deploy the Log Analytics Workspace. If true, the Log Analytics Workspace will be deployed. If false, the Log Analytics Workspace will not be deployed.')
param deploylogAnalyticsWorkspace bool

@description('Specifies whether to deploy the Action Group. If true, the Action Group will be deployed. If false, the Action Group will not be deployed.')
param deployActionGroup bool

@description('Specifies whether to deploy the Service Vault. If true, the Service Vault will be deployed. If false, the Service Vault will not be deployed.')
param deployServiceVault bool

@description('The location for global resources such as Private DNS Zones and Action Groups. This is typically set to "global" for these resources.')
param globalLocation string = 'global'

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
    routeTableId: deployRouteTable ? corpSpokeRouteTable!.outputs.routeTableId : ''
  }
}


// Empty Corp Route Table
module corpSpokeRouteTable '../modules/rt.bicep' = if (deployRouteTable){
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
  resourceName : 'sacorp${environment}'
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
    publicAccess : 'None'
    resourceName: 'sc-corp-${environment}'
    storageAccountName: storageAccount!.outputs.storageAccountName

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
    globalLocation : globalLocation
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

//diagnosticSettings for keyVault
module diagnosticSettings '../modules/diagnosticSettings.bicep' = if (deployKeyVault && deploylogAnalyticsWorkspace){
  name: 'deploy-diagnostic-settings'
  params: {
    resourceName: 'ds-corp-${environment}'
    keyVaultName: keyVault!.outputs.keyVaultName
    workspaceId: logAnalyticsWorkspace!.outputs.workspaceId
  }
}


//scheduledQueryRule
module scheduledQueryRule '../modules/scheduledQueryRule.bicep' = if (deploylogAnalyticsWorkspace && deployActionGroup){
  name: 'deploy-scheduled-query-rule'
  params: {
    resourceName: 'sqr-corp-${environment}'
    location: location
    scopes: [logAnalyticsWorkspace!.outputs.workspaceId]
    query: 'AzureDiagnostics | where ResourceProvider == "MICROSOFT.KEYVAULT" | where httpStatusCode_d in (401, 403)'
    actionGroupIds: [actionGroup!.outputs.actionGroupId] 
    severity: 3
    threshold: 0
    alertOperator: 'GreaterThan'
    timeAggregation: 'Count'
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    enabled: true
    autoMitigate: true
  }
}

// Outputs
output corpSpokeVnetId string = corpSpokeVnet.outputs.vnetId
output corpSpokeSubnetId string = corpSpokeSubnet.outputs.subnetId
output corpSpokeNsgId string = corpSpokeNsg.outputs.nsgId
output keyVaultId string = keyVault!.outputs.keyVaultId
output managedIdentityId string = managedIdentity!.outputs.identityId
output corpSpokePrivateDnsZoneId string = corpSpokePrivateDnsZone!.outputs.privateDnsZoneId
output storageAccountId string  = storageAccount!.outputs.storageAccountId
output storageAccountName string  = storageAccount!.outputs.storageAccountName
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace!.outputs.workspaceName
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace!.outputs.workspaceId
