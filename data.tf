data "aws_secretsmanager_secret" "secret" {
  name = "roboshop/all"
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

data "aws_ami" "main" {
  //executable_users = ["self"]
  most_recent      = true
  name_regex       = "${var.COMPONENT}-${var.APP_VERSION}"
  owners           = ["self"]
}

data "aws_ec2_spot_price" "spot_price" {
  instance_type     = var.INSTANCE_TYPE
  availability_zone = data.aws_subnet.selected.availability_zone

  filter {
    name   = "product-description"
    values = ["Linux/UNIX"]
  }
}

data "aws_subnet" "selected" {
  id = var.PRIVATE_SUBNET_ID[0]
}

