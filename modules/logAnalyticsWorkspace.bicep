@description('')
param resourceName string

@description('')
param location string

@description('')
param disableLocalAuth bool

@description('')
param enableLogAccessUsingOnlyResourcePermissions bool

@description('')
param publicNetworkAccessForIngestion string

@description('')
param publicNetworkAccessForQuery string

@description('')
param retentionDays int

@description('')
param skuName string

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: resourceName
  location: location
  properties: {
    features: {
      disableLocalAuth: disableLocalAuth
      enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermissions
    }
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    retentionInDays: retentionDays
    sku: {
      name: skuName
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
  }
}
output workspaceId string = workspace.id
output workspaceName string = workspace.name
