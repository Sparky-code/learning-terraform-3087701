output "instance_image_id" {
    value = azurerm_linux_virtual_machine.web.storage_image_reference.id
}

output "instance_id" {
    value = azurerm_linux_virtual_machine.web.id
}