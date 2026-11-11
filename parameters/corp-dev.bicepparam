
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
param deploystorgeAccount = true

//values for log Analytics workspace
param deploylogAnalyticsWorkspace = true

//values for actiongroup
param deployActionGroup = true

//values for recoveryServiceVault
param deployServiceVault = true

//values for route table
param deployRouteTable = true
