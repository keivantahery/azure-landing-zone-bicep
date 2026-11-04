
targetScope = 'resourceGroup'

param location string
param environment string
param corpSpokeAddressPrefixes array
param corpSpokeSubnetAddressPrefixes array
param tenantId string
param deployKeyVault bool
param keyVaultName string
param principalType string


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

module keyVault '../modules/keyvault.bicep' = if (deployKeyVault){
  name: 'deploy-key-vault'
  params: {
    keyVaultName: keyVaultName
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

// Outputs
output corpSpokeVnetId string = corpSpokeVnet.outputs.vnetId
output corpSpokeSubnetId string = corpSpokeSubnet.outputs.subnetId
output corpSpokeNsgId string = corpSpokeNsg.outputs.nsgId
output keyVaultId string = keyVault.outputs.keyVaultId
output managedIdentityId string = managedIdentity.outputs.identityId
output corpSpokePrivateDnsZoneId string = corpSpokePrivateDnsZone.outputs.privateDnsZoneId
