@description('The name of the DNS zone to be created.  Must have at least 2 segments, e.g. hostname.org')
param zoneName string

@description('The name of the DNS record to be created.  The name is relative to the zone, not the FQDN.')
param recordName string 

@description('The IPv4 address to be associated with the DNS record.')
param ipv4Address string



resource zone 'Microsoft.Network/privateDnsZones@2018-09-01' existing = {
  name:zoneName
}

resource record 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  parent: zone
  name: recordName
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address:  ipv4Address
      }
     
    ]
  }
}

output dnsRecordId string = record.id
