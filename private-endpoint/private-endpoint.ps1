# Variables
$storageAccountName = "twstg1a"
$privateEndpointName = "twstg1a-pa"
$resourceGroupName = "<ResourceGroupName>" # Replace with your Resource Group Name
$vnetName = "hub-vnet"
$subnetName = "data"
$privateIP = "10.10.1.100"
$privateDnsZoneName = "privatelink.blob.core.windows.net"

# Get the storage account
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName

# Get the blob service's resource ID
$blobServiceResourceId = $storageAccount.Id + "/blobServices/default"

# Get the subnet
$subnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName |
          Get-AzVirtualNetworkSubnetConfig -Name $subnetName

# Create or get the private DNS zone
$privateDnsZone = Get-AzPrivateDnsZone -Name $privateDnsZoneName -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue
if ($null -eq $privateDnsZone) {
    $privateDnsZone = New-AzPrivateDnsZone -Name $privateDnsZoneName -ResourceGroupName $resourceGroupName
}

# Create a private link service connection
$privateLinkServiceConnection = New-AzPrivateLinkServiceConnection -Name $privateEndpointName `
                                                                -PrivateLinkServiceId $blobServiceResourceId `
                                                                -GroupIds "blob" `
                                                                -RequestMessage "Please approve this private endpoint."

# Configure the private endpoint IP configuration
$privateEndpointIpConfig = New-AzPrivateEndpointIpConfig -Name "IpConfig1" -PrivateIpAddress $privateIP -Subnet $subnet

# Create the private endpoint
$privateEndpoint = New-AzPrivateEndpoint -ResourceGroupName $resourceGroupName -Name $privateEndpointName `
                      -Location $storageAccount.Location -PrivateLinkServiceConnection $privateLinkServiceConnection `
                      -PrivateEndpointIpConfig $privateEndpointIpConfig

# Link the private DNS zone to the virtual network
New-AzPrivateDnsVirtualNetworkLink -ZoneName $privateDnsZone.Name -ResourceGroupName $resourceGroupName `
                                   -Name "VNetLink" -VirtualNetworkId $vnet.ResourceId -EnableRegistration

Write-Host "Private endpoint and private DNS zone have been created."
