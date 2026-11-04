
using '../networking/main.bicep'

param location = 'australiaeast'
param environment = 'dev'

param hubAddressPrefixes = [
  '10.0.0.0/16'
]

param hubSubnetPrefix = '10.0.1.0/24'
