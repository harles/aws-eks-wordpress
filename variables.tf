# cluster variables
# no default values used to force users to think and specify correct ones
# credentials are specified in sensitive.auto.tfvars, others in terraform.auto.tfvars

variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "provisioner" {}
variable "environment" {}
variable "domain" {}
variable "application" {}

# database variable
variable "db_master_username" {}
variable "db_master_password" {}

# other
variable "home_cidr" {}
