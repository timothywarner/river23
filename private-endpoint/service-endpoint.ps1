# Variables
$resourceGroupName = "<ResourceGroupName>" # Replace with your Resource Group Name
$vnetName = "hub-vnet"
$subnetName = "data"

# Get the virtual network
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName

# Get the existing subnet
$subnetConfig = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet

# Add the service endpoint for the storage service to the subnet configuration
$subnetConfig.ServiceEndpoint.Add((
    New-AzDelegation `
        -Name "Microsoft.Storage" `
        -ServiceName "Microsoft.Storage"
))

# Set the virtual network configuration with the updated subnet
Set-AzVirtualNetwork -VirtualNetwork $vnet

Write-Host "Service endpoint for Azure Storage has been added to the subnet."
