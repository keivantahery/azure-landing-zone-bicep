@description('specifiesd the location of the actongroup')
param globalLocation string

@description('specifie the name of the actiongroup')
param resourceName string

@description('Notifies users assigned to specified Azure RBAC roles at the subscription scope.')
param armRoleReceivers array

@description('Triggers Azure Automation runbooks when alerts fire')
param automationRunbookReceivers array

@description('Sends push notifications to registered Azure mobile app users')
param azureAppPushReceivers array

@description('Invokes Azure Functions to execute custom alert-handling logic')
param azureFunctionReceivers array

@description('Sends email notifications to specified email addresses')
param emailReceivers array

@description('Determines whether the action group is enabled')
param isActionGroupEnabled bool

@description(' Sends alert notifications to an Azure Event Hub')
param eventHubReceivers array

@description('A short name for the action group')
param actionGroupShortName string

@description('Integrates with IT Service Management (ITSM) tools to create incidents or tickets when alerts fire')
param itsmReceivers array

@description('Invokes Logic Apps to execute custom alert-handling logic')
param logicAppReceivers array

@description(' Sends SMS notifications to specified phone numbers')
param smsReceivers array

@description('Sends voice notifications to specified phone numbers')
param voiceReceivers array

@description('Sends webhook notifications to specified endpoints')
param webhookReceivers array


resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: resourceName
  location: globalLocation
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

output actionGroupName string = actionGroup.name
output actionGroupId string = actionGroup.id
