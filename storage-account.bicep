// Module made for demostration only

@description('Provide the target WorkspaceID')
param logAnalyticsWorkspaceId string
@minLength(3)
@maxLength(24)
@description('''Htorne Module \
Remeber this must be unique across all of Azure

''')
param name_storage_account string
@description('''
Htorne Module \
Location of the resource - typically the same as the resoruce group''')
param location string
@description('''
Htorne Module \
\
•	Premium_LRS stands for Premium Locally Redundant Storage and is expensive - use this for high-performance needs like databases. \
•	Premium_ZRS stands for Premium Zone Redundant Storage and is expensive - use this for high-availability scenarios within a region. \
•	Standard_GRS stands for Standard Geo-Redundant Storage and is moderately priced - use this for disaster recovery with secondary region replication. \
•	Standard_GZRS stands for Standard Geo Zone Redundant Storage and is moderately priced - use this for high availability and geo-redundancy. \
•	Standard_LRS stands for Standard Locally Redundant Storage and is cost-effective - use this for low-cost, locally redundant data storage. \
•	Standard_RAGRS stands for Standard Read-Access Geo-Redundant Storage and is moderately priced - use this for read access to the secondary region for disaster recovery. \
•	Standard_RAGZRS stands for Standard Read-Access Geo Zone Redundant Storage and is moderately priced - use this for read access to geo-zone redundant storage for disaster recovery. \
•	Standard_ZRS stands for Standard Zone Redundant Storage and is moderately priced - use this for data redundancy within a region across availability zones. \
''')
@allowed( [
  'Premium_LRS' 
  'Premium_ZRS' 
  'Standard_GRS'  
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'  
])
param storage_sku string 

@description('''

    Htorne Module

	•	BlobStorage \
    is optimized for storing unstructured data like text and binary data - use this for large-scale object storage and data lakes. 
	
  •	BlockBlobStorage \
    is optimized for high transaction rates and large object storage - use this for uploading large blocks of data, like media files or logs. 
	
  •	FileStorage \
    is optimized for fully managed file shares in the cloud - use this for migrating existing file shares or creating new cloud-native applications. 
	
  •	Storage \
    is a general-purpose v1 account that supports blobs, files, queues, and tables - use this for legacy applications or basic storage needs. 

  •	StorageV2 \  
    is a general-purpose v2 account that supports all the latest features - use this for most new applications and enhanced performance features. 

''')
@allowed( [
  'BlobStorage' 
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2' 
])
param kind string

@description('''
Htorne Module

Specifies the access tier for BlobStorage.'.
''')
@allowed([
         'Hot'
         'Cool'
         'Cold'
         'Premium'
        ])
param access_tier string 
resource storage_account 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: name_storage_account
  location: location
  sku: {
    name: storage_sku
  }
  kind: kind
  properties:  {
     accessTier: access_tier
      
  }
}

resource diagnosticsStorae 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diagnostics00'
  scope: storage_account
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

