@description('Globally unique name for the OpenAI service instance')
param name string = 'twopenai01ae'

@description('Location inherited from parent resource group')
param location string = resourceGroup().location

@allowed([
  'S0'
])
@description('Pricing tier')
param sku string = 'S0'

resource open_ai 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: name
  location: location
  kind: 'OpenAI'
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: toLower(name)
  }
}
