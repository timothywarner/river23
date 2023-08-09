# Set variables
$storageAccountName = "twgpcloud01"
$keyVaultName = "certstar-keyvault"
$keyName = "twgpcloud01"

# Get the storage account resource ID
$storageAccountResourceId = (Get-AzStorageAccount -Name $storageAccountName).Id

# Create a new key in the key vault
$key = Add-AzKeyVaultKey `
  -VaultName $keyVaultName `
  -Name $keyName `
  -Destination $storageAccountResourceId `
  -DestinationKeyIdentifier "https://${keyVaultName}.vault.azure.net/keys/${keyName}"

# Enable customer-managed encryption for the storage account
Set-AzStorageAccount `
  -Name $storageAccountName `
  -ResourceGroupName $key.ResourceGroupName `
  -EncryptionServices `
  @{ 
    "blob" = @{ 
      "enabled" = $true 
      "keySource" = "Microsoft.KeyVault" 
      "keyVaultProperties" = @{ 
        "keyVaultUri" = "https://${keyVaultName}.vault.azure.net" 
        "keyName" = $keyName 
        "keyVersion" = $key.Version 
      } 
    } 
  }