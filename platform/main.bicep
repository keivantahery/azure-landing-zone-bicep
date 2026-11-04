
targetScope = 'subscription'

param location string
param environment string

module managementRg '../modules/resource-group.bicep' = {
  name: 'deploy-management-rg'
  params: {
    resourceGroupName: 'rg-management-${environment}'
    location: location
    tags: {
      Environment: environment
      Purpose: 'Management'
    }
  }
}





module networkingRg '../modules/resource-group.bicep' = {
  name: 'deploy-networking-rg'
  params: {
    resourceGroupName: 'rg-networking-${environment}'
    location: location
    tags: {
      Environment: environment
      Purpose: 'Networking'
    }
  }
}



module securityRg '../modules/resource-group.bicep' = {
  name: 'deploy-security-rg'
  params: {
    resourceGroupName: 'rg-security-${environment}'
    location: location
    tags: {
      Environment: environment
      Purpose: 'Security'
    }
  }
}



module workloadsRg '../modules/resource-group.bicep' = {
  name: 'deploy-workloads-rg'
  params: {
    resourceGroupName: 'rg-workloads-${environment}'
    location: location
    tags: {
      Environment: environment
      Purpose: 'Workloads'
    }
  }
}



module corpRg '../modules/resource-group.bicep' = {
  name: 'deploy-corp-rg'
  params: {
    resourceGroupName: 'rg-corp-${environment}'
    location: location
    tags: {
      Environment: environment
      Purpose: 'Corp-Spoke'
    }
  }
}



output managementResourceGroupId string = managementRg.outputs.resourceGroupId
