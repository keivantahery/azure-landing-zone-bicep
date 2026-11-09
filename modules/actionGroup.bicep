@description('specifiesd the location of the actongroup')
param location string

@description('specifie the name of the actiongroup')
param resourceName string

@description('allows you to send alert notifications to all members of a specific Azure Resource Manager')
param armRoleReceivers array

@description('allows you to send alert notifications to all members of a specific automation runbook')
param automationRunbookReceivers array

@description('')
param azureAppPushReceivers array

@description('')
param azureFunctionReceivers array

@description('')
param emailReceivers array

@description('')
param isActionGroupEnabled bool

@description('')
param eventHubReceivers array

@description('')
param actionGroupShortName string

@description('')
param itsmReceivers array

@description('')
param logicAppReceivers array

@description('')
param smsReceivers array

@description('')
param voiceReceivers array

@description('')
param webhookReceivers array


resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: resourceName
  location: location
  properties: {
    armRoleReceivers: armRoleReceivers
    automationRunbookReceivers: automationRunbookReceivers
    azureAppPushReceivers: azureAppPushReceivers
    azureFunctionReceivers: azureFunctionReceivers
    emailReceivers: emailReceivers
    enabled: isActionGroupEnabled
    eventHubReceivers: eventHubReceivers
    groupShortName: actionGroupShortName
    itsmReceivers: itsmReceivers
    logicAppReceivers: logicAppReceivers
    smsReceivers: smsReceivers
    voiceReceivers: voiceReceivers
    webhookReceivers: webhookReceivers
  }
}

output actiogGroupName string = actionGroup.name
output actiogGroupId string = actionGroup.id
