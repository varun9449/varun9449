resource "azurerm_resource_group" "RG_01" {
  name     = var.resource_group_name
  location = var.location
}




resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.RG_01.location
  resource_group_name = azurerm_resource_group.RG_01.name
  address_space =     ["10.0.0.0/24"]
  tags = var.tags
}


resource "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.RG_01.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/27"]

  
}

resource "azurerm_public_ip" "pubip" {
  name                = var.pubip
  resource_group_name = azurerm_resource_group.RG_01.name
  location            = azurerm_resource_group.RG_01.location
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.RG_01.location
  resource_group_name = azurerm_resource_group.RG_01.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "win"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 5986
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

security_rule {
    name                       = "winrm"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 5985
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.RG_01.location
  resource_group_name = azurerm_resource_group.RG_01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pubip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg-nic" {

  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.RG_01.name
  location            = azurerm_resource_group.RG_01.location
  size                = "Standard_F2"
  admin_username      = var.adminusername
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
