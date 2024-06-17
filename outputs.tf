output "source_image_id" {
    value = "${azurerm_linux_virtual_machine.example.source_image_reference[0].publisher}:${azurerm_linux_virtual_machine.example.source_image_reference[0].offer}:${azurerm_linux_virtual_machine.example.source_image_reference[0].sku}:${azurerm_linux_virtual_machine.example.source_image_reference[0].version}"
}

output "source_id" {
    value = azurerm_linux_virtual_machine.example.id
}