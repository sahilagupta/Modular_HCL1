module "resource_group" {
  source   = "../Automation_todo/resource group"
  name     = "rg-virat"
  location = "Australia east"
}

module "resource_group1" {
  source   = "../Automation_todo/resource group"
  name     = "rg-virat1"
  location = "Australia east"
}

module "virtual_network" {
  depends_on          = [module.resource_group]
  source              = "../Automation_todo/Virtual_network"
  name                = "virat_vnet"
  location            = "Australia east"
  resource_group_name = "rg-virat"
  address_space       = ["10.0.0.0/16"]

}

module "virtual_subnet" {
  depends_on = [module.virtual_network]

  source               = "../Automation_todo/subnet"
  subnet_name          = "frontend_virat"
  resource_group_name  = "rg-virat"
  virtual_network_name = "virat_vnet"
  address_prefixes     = ["10.0.1.0/24"]

}

module "subnet" {
  depends_on = [module.virtual_network]

  source               = "../Automation_todo/subnet"
  subnet_name          = "backend_virat"
  resource_group_name  = "rg-virat"
  virtual_network_name = "virat_vnet"
  address_prefixes     = ["10.0.2.0/24"]

}

module "public_ip" {
    depends_on = [module.subnet]
    source = "../Automation_todo/public_ip"
    name = "puplic_ip_virat"
    resource_group_name = "rg-virat"
    location = "Australia east"
}

module "vmfd" {
    depends_on = [module.subnet , module.public_ip]
    source = "../Automation_todo/VM"
    name = "frontendvm_nic-virat"
    location = "Australia east"
    resource_group_name = "rg-virat"
    subnet_id ="/subscriptions/5e489b50-4c7a-4aee-83ab-ebcd9be82c57/resourceGroups/rg-virat/providers/Microsoft.Network/virtualNetworks/virat_vnet/subnets/frontend_virat"
    vm_name = "frontendvm-virat"
    size = "Standard_B1s"
    admin_username = "Student"
    admin_password = "Nokia@123456789"
    publisher = "canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
}

module "vmbk" {
    depends_on = [module.subnet , module.public_ip]
    source = "../Automation_todo/VM"
    name = "backendvm_nic-virat"
    location = "Australia east"
    resource_group_name = "rg-virat"
    subnet_id ="/subscriptions/5e489b50-4c7a-4aee-83ab-ebcd9be82c57/resourceGroups/rg-virat/providers/Microsoft.Network/virtualNetworks/virat_vnet/subnets/backend_virat"
    vm_name = "backendvm-virat"
    size = "Standard_B1s"
    admin_username = "Student"
    admin_password = "Nokia@123456789"
    publisher = "canonical"
    offer = "0001-com-ubuntu-server-focal"
    sku = "20_04-lts"
}

# module "sql_server" {
#     depends_on = [ module.resource_group ]
#     source = "../Automation_todo/SQL_SERVER"
#     sql_name = "viratsqlserver"
#     resource_group_name = "rg-virat"
#     location = "Australia east"
#     administrator_login = "Student"
#     administrator_login_password = "Nokia@123456789"
# }

# module "database" {
#     depends_on = [ module.sql_server ]
#     source = "../Automation_todo/Database"
#     database_name = "viratdatabase"
#     server_id = "/subscriptions/5e489b50-4c7a-4aee-83ab-ebcd9be82c57/resourceGroups/rg-virat/providers/Microsoft.Sql/servers/viratsqlserver"
# }