extension microsoftGraphV1

@description('The display name for your application')
param appName string = 'MyBicepApp'

@description('The URI for the application login')
param redirectUri string = 'https://myapp.com/login'

// 1. Create the Application (App Registration)
resource appRegistration 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: appName
  displayName: appName
  signInAudience: 'AzureADMyOrg'
  web: {
    redirectUris: [
      redirectUri
    ]
  }
  requiredResourceAccess: [
    {
      resourceAppId: '00000003-0000-0000-c000-000000000000' // MS Graph ID
      resourceAccess: [
        {
          id: 'e1fe6dd5-8c31-4d11-8a82-051444c03332' // User.Read
          type: 'Scope'
        }
      ]
    }
  ]
}

// 2. Create the Service Principal
resource servicePrincipal 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: appRegistration.appId
}

output clientId string = appRegistration.appId
output servicePrincipalId string = servicePrincipal.id