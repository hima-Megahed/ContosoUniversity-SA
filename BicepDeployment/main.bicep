@description('Sql admin login')
param sqlAdminLogin string

@description('Sql Admin Password')
@secure()
param sqlAdminPassword string

@description('Name of Azure web app')
param siteName string

@description('Location for all resources')
param location string = resourceGroup().location

var hostingPlaneName = '${siteName}-serviceplan'
var uniqueSiteName = '${siteName}-${uniqueString(resourceGroup().id)}'
var websiteName = 'website-${uniqueSiteName}'
var sqlServerName = 'contoso-sqlserver-${uniqueString(resourceGroup().id)}'
var databaseName = 'database-${uniqueSiteName}'
var skuName = 'F1'

resource hostingPlane 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: hostingPlaneName
  location: location
  sku: {
    name: skuName
  }
}

resource webSite 'Microsoft.Web/sites@2022-03-01' = {
  name: websiteName
  location: location
  tags: {
    'hidden-related:${hostingPlane.id}' : 'empty'
    displayName : 'Website'
  }
  properties: {
    httpsOnly: true
    serverFarmId: hostingPlane.id
    clientAffinityEnabled: false
    siteConfig: {
      netFrameworkVersion: 'v6.0'
      ftpsState: 'FtpsOnly'
      
    }
  }
}

resource connectionString 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'connectionstrings'
  parent: webSite
  properties: {
    LevelUpUniversityDatabase: {
      type: 'SQLAzure'
      value: 'Data Source=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};User Id=${sqlAdminLogin}@${sqlServer.properties.fullyQualifiedDomainName};Password=${sqlAdminPassword};'
    }
  }
}

/* resource CICD_Website 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  name: 'web'
  parent: webSite
  properties: {
    isGitHubAction: true
    repoUrl: 'https://github.com/hima-Megahed/ContosoUniversity'
    branch: 'master'
    gitHubActionConfiguration: {
      generateWorkflowFile: false
      isLinux: false
      codeConfiguration: {
        runtimeStack: 'dotnet'
        runtimeVersion: '6.0.x'
      }
    }
  }
} */

resource appInsights_webApp 'Microsoft.Insights/components@2020-02-02' = {
  name: 'AppInsights-${webSite.name}'
  location: location
  kind: 'web'
  tags: {
    'hidden-link:${webSite.id}': 'Resource'
    displayName: 'AppInsightsComponent'
  }
  properties: {
    Application_Type: 'web'
  }
}


// ================== Createing SQL Azure Db =========================

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
  }
}

resource database 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  name: databaseName
  parent: sqlServer
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
  }
}

resource sqlServer_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  name: 'AllowAllWindowsAzureIps'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}
