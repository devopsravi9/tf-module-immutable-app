variable "PRIVATE_SUBNET_ID" {}
variable "PORT" {}
variable "ALLOW_SG_CIDR" {}
variable "ENV" {}
variable "VPC_ID" {}
variable "INSTANCE_TYPE" {}
variable "WORKSTATION_IP" {}
variable "COMPONENT" {}
variable "LB_ARN" {}
variable "LB_TYPE" {}
variable "PRIVATE_ZONE_ID" {}
variable "PRIVATE_LB_DNS" {}
variable "PRIVATE_LISTENER_ARN" {}
variable "DOCDB_ENDPOINT" {
  default = "null"
}
variable "REDDIS_ENDPOINT" {
  default = "null"
}
variable "MYSQL_ENDPOINT" {
  default = "null"
}

variable "PROMETHEUS_IP" {}
variable "APP_VERSION" {}

variable "ASG_DESIRED" {}
variable "ASG_MAX" {}
variable "ASG_MIN" {}