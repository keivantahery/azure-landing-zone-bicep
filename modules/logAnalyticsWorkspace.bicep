@description('Name of the Log Analytics Workspace.')
param resourceName string

@description('Location of the Log Analytics Workspace.')
param location string

@description('Determines whether local authentication is disabled.')
param disableLocalAuth bool

@description('Determines whether log access is enabled using only resource permissions.')
param enableLogAccessUsingOnlyResourcePermissions bool

@description('Specifies the public network access for ingestion.')
param publicNetworkAccessForIngestion string

@description('Specifies the public network access for query.')
param publicNetworkAccessForQuery string

@description('Specifies the retention period for the Log Analytics Workspace in days.')
param retentionDays int

@description('Specifies the SKU name for the Log Analytics Workspace.')
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
