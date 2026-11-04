
@description('Azure region')
param location string

@description('Route table name')
param resourceName string

@description('Disable BGP route propagation')
param disableBgpRoutePropagation bool = false

@description('Optional custom routes')
param routes array = []

resource routeTable 'Microsoft.Network/routeTables@2022-09-01' = {
  name: resourceName
  location: location
  properties: {
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: routes
  }
}

output routeTableId string = routeTable.id
