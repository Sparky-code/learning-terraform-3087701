provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "terraform-westus"
  location = "West US"
}

resource "azurerm_virtual_network" "example" {
  name                = "terraform-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
  domain_name_label   = "something-super-unique-asdf3452kllka2345"  // replace with your desired domain name label
}

resource "azurerm_network_interface" "example" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = "Password12345!" 

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.blog.id
}

resource "azurerm_network_security_group" "blog" {
  name = "blog"
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
      description = "Allow HTTP and HTTPS in. Allow all traffic out."
  }
}

resource "azurerm_network_security_rule" "blog_http_in" {
  description = "Allow HTTP/HTTPS in"
  name                        = "http"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.blog.name
}

resource "azurerm_network_security_rule" "blog_https_in" {
  description = "Allow HTTP/HTTPS in"
  name                        = "http"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "443"
  destination_port_range      = "443"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.blog.name
}

resource "azurerm_network_security_rule" "blog_everything_out" {
  description = "Allow HTTP/HTTPS in"
  name                        = "http"
  priority                    = 1001
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.blog.name
}