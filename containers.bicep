// Module made for demostration only

@description('''
Htorne Module \
\
Name of parent Storage Account''')
param parentSAName string

@description('''
Htorne Module \
\
Array of containers to create.
Example:
[
  'container1'
  'container2'
  'container3'
]
''')
param containerNames array = []

@description('''
Htorne Module \
\
Enable logging - true or false
''')
param enableLogging bool = false

@description('''
Htorne Module \
\
Log retention in days. Default is 180.
''')
param logsRetentionInDays int = 180

@description('''
Htorne Module \
\
ID of the workspace to send the logs to
''')
param workspaceID string = ''

resource storage_account 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: parentSAName
}

resource blob_service 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  parent: storage_account
  name: 'default'
}

resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' =  [for name in containerNames: {
  name: name
  parent: blob_service
}]

// logging

resource logging_service 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if(enableLogging) {
  scope: blob_service
  name: 'service'
  properties: {
    logAnalyticsDestinationType: null
    workspaceId: workspaceID
    logs: [
      {
        category: 'StorageDelete'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logsRetentionInDays
        }
      }
      {
        category: 'StorageRead'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logsRetentionInDays
        }
      }
      {
        category: 'StorageWrite'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logsRetentionInDays
        }
      }
    ]
  }
}

output containerNames array = containerNames
