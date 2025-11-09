locals {
  name = "${var.project_name}-${var.env}"
}

resource "azurerm_resource_group" "rg" {
  name = "rg-${local.name}"
  location = var.location
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name = "${local.name}-vnet"
  address_space = ["10.30.0.0/16"]
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name = "${local.name}-subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.30.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name = "${local.name}-nic"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "ipcfg"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = "${local.name}-vm"
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [ azurerm_network_interface.nic.id ]
  size = var.vm_size
  admin_username = var.admin_username

  admin_ssh_key {
    username = var.admin_username
    public_key = file(var.ssh_pub_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

output "vm_name"   { value = azurerm_linux_virtual_machine.vm.name }
output "nic_name"  { value = azurerm_network_interface.nic.name }
output "subnet_id" { value = azurerm_subnet.subnet.id }
output "vnet_name" { value = azurerm_virtual_network.vnet.name }