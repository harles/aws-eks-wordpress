provider "aws" {
  version = ">= 2.28.1"
  region  = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
