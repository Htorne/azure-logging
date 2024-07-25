// Module made for demostration only

@description('''
Htorne Module \
Log Analytics Workspace Name \ 
Workspace name must start and end with an alphanumeric character, and may contain only alphanumeric and hyphen characters ''')
param name_loganlytics string
@description('''
Htorne Module \
Location of the resource - typically the same as the resoruce group''')
param location string
@description('''
Htorne Module \
Keep in mind this is very expensive \
Log Retention In Days \
Minimum is 30 days''')
@minValue(30)
param log_retention int
@description('''
Htorne Module \
If set to i.g. 1 Gb logging will stop once 1Gb of logs has been collected and start again on the next day. \
\
Use this carefully \
\
The workspace daily quota for ingestion, in GigaBytes.''')
param dailyQuotaGb int


resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name_loganlytics
  location: location
   properties: {
     sku: {
      name: 'PerGB2018'
        }
         retentionInDays: log_retention
    workspaceCapping: {
       dailyQuotaGb: dailyQuotaGb
    }
        }
}

output WorkspaceID string = logAnalyticsWorkspace.id
