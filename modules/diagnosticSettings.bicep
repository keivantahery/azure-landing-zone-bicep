
@description('')
param resourceName string

@description('')
param resourceScope string

@description('')
param logsCategoryGroup string

@description('')
param enableLogDiagnosticSettings bool

@description('')
param logRetention int

@description('')
param enableLogRentention bool

@description('')
param metricCategory string

@description('')
param enableMetrics bool

@description('')
param metricRetention int


resource authorizationRule 'Microsoft.EventHub/namespaces/authorizationRules@2021-11-01' = {
  name: 'example'
  parent: namespace
  properties: {
    rights: [
      'Listen'
      'Send'
      'Manage'
    ]
  }
}


resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: resourceName
  scope: resourceScope
  properties: {
    eventHubAuthorizationRuleId: authorizationRule.id
    eventHubName: namespace.name
    logs: [
      {
        categoryGroup: logsCategoryGroup
        enabled: enableLogDiagnosticSettings
        retentionPolicy: {
          days: logRetention
          enabled: enableLogRentention
        }
      }
    ]
    metrics: [
      {
        category: metricCategory
        enabled: enableMetrics
        retentionPolicy: {
          days: metricRetention
          enabled: false
        }
      }
    ]
  }
}
