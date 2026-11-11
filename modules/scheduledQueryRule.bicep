
targetScope = 'resourceGroup'

@description('Name of the scheduled query alert rule.')
param resourceName string

@description('Azure region where the alert rule is deployed.')
param location string

@description('Resource IDs of the Log Analytics workspaces or resources to monitor.')
param scopes array

@description('KQL query used to evaluate the alert.')
param query string

@description('Action Group resource IDs to notify.')
param actionGroupIds array

@description('Alert severity from 0 (critical) to 4 (verbose).')
@minValue(0)
@maxValue(4)
param severity int

@description('Threshold value that triggers the alert.')
param threshold int

@description('Comparison operator for the threshold.')
param alertOperator string

@description('Aggregation method for the query results.')
param timeAggregation string

@description('How frequently the alert is evaluated.')
param evaluationFrequency string

@description('Time window evaluated by the query.')
param windowSize string

@description('Enables or disables the alert rule.')
param enabled bool

@description('Automatically resolve alerts when the condition clears.')
param autoMitigate bool

resource scheduledQueryRule 'Microsoft.Insights/scheduledQueryRules@2023-12-01' = {
  name: resourceName
  location: location
  kind: 'LogAlert'
  properties: {
    displayName: resourceName
    description: 'Log Analytics scheduled query alert'
    enabled: enabled
    severity: severity
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    autoMitigate: autoMitigate
    scopes: scopes
    criteria: {
      allOf: [
        {
          query: query
          operator: alertOperator
          threshold: threshold
          timeAggregation: timeAggregation
        }
      ]
    }
    actions: {
      actionGroups: actionGroupIds
    }
  }
}

output alertRuleId string = scheduledQueryRule.id
output alertRuleName string = scheduledQueryRule.name
