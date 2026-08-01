resource "azurerm_resource_group" "hub" {
  name     = "rsg-nxp-central-hub"
  location = var.location

  tags = merge(local.common_tags, {
    role = "networkhub"
  })
}

resource "azurerm_resource_group" "student" {
  for_each = var.students

  name     = "rsg-nxp-${each.key}"
  location = var.location

  tags = merge(local.common_tags, {
    role         = "student-pod"
    student_code = each.key
    student_name = each.value.display_name
  })
}