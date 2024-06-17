output "source_image_id" {
    value = "${azurerm_linux_virtual_machine.web.source_image_reference.publisher}:${azurerm_linux_virtual_machine.web.source_image_reference.offer}:${azurerm_linux_virtual_machine.web.source_image_reference.sku}:${azurerm_linux_virtual_machine.web.source_image_reference.version}"
}

output "source_id" {
    value = azurerm_linux_virtual_machine.web.id
}