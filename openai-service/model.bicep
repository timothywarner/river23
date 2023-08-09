param openaiResourceName string = 'myOpenAIResource'
param openaiLocation string = 'eastus'
param openaiSku string = 'S0'
param openaiApiKey string
param openaiModelName string = 'gpt-35-turbo'
param openaiModelUrl string

resource openaiResource 'Microsoft.OpenAI/openaiservices@2021-07-01-preview' = {
  name: openaiResourceName
  location: openaiLocation
  sku: {
    name: openaiSku
  }
  properties: {
    apiKey: openaiApiKey
  }
}

resource openaiModel 'Microsoft.OpenAI/openaiservices/models@2021-07-01-preview' = {
  name: '${openaiResourceName}/${openaiModelName}'
  properties: {
    url: openaiModelUrl
  }
  dependsOn: [
    openaiResource
  ]
}
