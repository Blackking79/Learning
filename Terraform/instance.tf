provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "intro" {
    ami = "ami-0dbc3d7bc646e8516"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = Control
    vpc_security_group_ids = [ "sg-053136960457e705c" ]
    tags = {
      name = "intro"
    }
}