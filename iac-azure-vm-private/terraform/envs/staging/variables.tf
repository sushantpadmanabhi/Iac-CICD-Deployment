variable "location" {
  type = string 
  default = "centralindia"
}

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "admin_username" {
  type = string
  default = "azureuser"
}

variable "ssh_pub_key_path" {
  type = string
  default = "id_rsa.pub"
}

variable "vm_size" {
  type = string
  default = "Standard_B1s"
}

variable "subscription_id" {
  type = string
}