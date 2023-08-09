$deploymentName = "openai-deployment"
$location = "eastus"
$templateFile = "../openai.solution.bicep"
$parameters = @{
    "envName" = "dev"
    "resourceGroupName" = "rg-test-openai"
    "resourceGroupLocation" = "westeurope"
    "openAiServiceName" = "oai-demoopenai-bicep"
    "openAiCustomDomain" = "demo-openai-bicep"
    "openAiResourceGroupLocation" = "eastus"
    "openAiSkuName" = "S0"
    "openAiDeploymentName" = "copilot"
    "openAiDeploymentModelName" = "gpt-35-turbo"
    "openAiDeploymentModelVersion" = "0301"
}

New-AzDeployment `
    -Name $deploymentName `
    -Location $location `
    -TemplateFile $templateFile `
    -TemplateParameterObject $parameters