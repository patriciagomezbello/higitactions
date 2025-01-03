terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.11"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "databricks" {
    host = azurerm_databricks_workspace.db-workspace.workspace_url
}

resource "azurerm_databricks_workspace" "db-workspace" {
  name                        = "DBW-ansuman"
  resource_group_name         = azurerm_resource_group.db-workspace.name
  location                    = azurerm_resource_group.db-workspace.location
  sku                         = "premium"
  managed_resource_group_name = "ansuman-DBW-managed-without-lb"

  public_network_access_enabled = true

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = azurerm_subnet.public.name
    private_subnet_name = azurerm_subnet.private.name
    virtual_network_id  = azurerm_virtual_network.db-workspace.id

    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  tags = {
    Environment = "Production"
    Pricing     = "Standard"
  }
}
data "databricks_node_type" "smallest" {
  local_disk = true
    depends_on = [
    azurerm_databricks_workspace.db-workspace
  ]
}
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
    depends_on = [
    azurerm_databricks_workspace.db-workspace
  ]
}
resource "databricks_cluster" "dbcselfservice" {
  cluster_name            = "Shared Autoscaling"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 7
  }
  azure_attributes {
    availability       = "SPOT_AZURE"
    first_on_demand    = 1
    spot_bid_max_price = 100
  }
  depends_on = [
    azurerm_databricks_workspace.db-workspace
  ]
}
resource "databricks_group" "db-group" {
  display_name               = "adb-users-admin"
  allow_cluster_create       = true
  allow_instance_pool_create = true
  depends_on = [
    resource.azurerm_databricks_workspace.db-workspace
  ]
}
resource "databricks_user" "dbuser" {
  display_name     = "Patricia Gomez Bello"
  user_name        = "db-workspace@mail.com"
  workspace_access = true
  depends_on = [
    resource.azurerm_databricks_workspace.db-workspace
  ]
}
resource "databricks_group_member" "i-am-admin" {
  group_id  = databricks_group.db-group.id
  member_id = databricks_user.dbuser.id
  depends_on = [
    resource.azurerm_databricks_workspace.db-workspace
  ]
}