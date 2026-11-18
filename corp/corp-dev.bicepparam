
using '../corp/main.bicep'

//values for the tenancy
param tenantId = '510827d0-a3e7-4823-91d5-c2b7bb907aba'
param location = 'australiaeast'
param environment = 'dev'

//values for the vnet
param corpSpokeAddressPrefixes = [
  '10.1.0.0/16'
]

//values for the spoke subnet
param corpSpokeSubnetAddressPrefixes  = [
  '10.1.0.0/24'
]

//values for the keyvalult
param deployKeyVault = true

//values for the role assignment
param principalType = 'ServicePrincipal' // or 'User'

//values for storage account
param deploystorgeAccount = false

//values for log Analytics workspace
param deploylogAnalyticsWorkspace = false

//values for actiongroup
param deployActionGroup = false

//values for recoveryServiceVault
param deployServiceVault = false

//values for route table
param deployRouteTable = false

//values for private endpoint
param deployPrivateEndpoint = true
param groupIds = [
  'vault'
]

//values for private DNS zone keyvault
param deployPrivateDnsZone = false

//values for private DNS zone keyvault
param deployPrivateDnsZoneKeyvault = true
