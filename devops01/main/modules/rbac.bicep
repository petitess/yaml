targetScope = 'subscription'

param principalId string
param role string

var roles = {
  'Network Contributor': '4d97b98b-1d4f-4787-a291-c67834d212e7'
  'Key Vault Admin': '00482a5a-887f-4fb3-b363-3b7fe8e74483'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
}

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: roles[role]
  scope: subscription()
}

resource rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, principalId, roleDefinition.id)
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinition.id
  }
}
