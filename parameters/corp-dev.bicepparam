
using '../corp/main.bicep'

param tenantId = '510827d0-a3e7-4823-91d5-c2b7bb907aba'
param location = 'australiaeast'
param environment = 'dev'
param corpSpokeAddressPrefixes = [
  '10.1.0.0/16'
]


// The value for the spoke subnet
param corpSpokeSubnetAddressPrefixes  = [
  '10.1.0.0/24'
]




// The values for the route table

//values for the keyvalult
param deployKeyVault = true
param keyVaultName = 'kv-corp-${environment}-5108'

// The values for the role assignment
param principalType = 'ServicePrincipal' // or 'User'
