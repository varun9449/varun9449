variable "resource_group_name" {
  type        =  string
  description = "Name of the resource group"
  default     = "RG_05"
}

variable "location" {
  type        =  string
  description = "Name of the location"
  default     = "eastus"
}

variable "tags" {
  default     = {
      createdby = "varunteja0706@gmail.com"
      environment = "development"
      project = "azure"
      "department"= "IT"
  }
}

variable "virtual_network_name" {
  type        =  string
  description = "Name of the vnet"
  default     = "vnet-01"
}

variable "subnet_name" {
  type        =  string
  description = "Name of the subnet"
  default     = "sub1"
}

variable "nsg_name" {
  type        =  string
  description = "Name of the subnet"
  default     = "varnsg"
}

variable "nic_name" {
  type        =  string
  description = "Name of the subnet"
  default     = "varnic"
}

variable "vm_name" {
  type        =  string
  description = "Name of the subnet"
  default     = "var-vm-01"
}

variable "adminusername" {
  type        =  string
  description = "Name of the subnet"
  default     = "azureuser"
}

variable "admin_password" {
  type        =  string
  description = "Name of the subnet"
  default     = "Azure@123456"
}


variable "pubip" {
  type        =  string
  description = "Name of the subnet"
  default     = "varpub-01"
}

