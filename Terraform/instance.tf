resource "aws_instance" "intro" {
    ami = var.AMIS[var.region]
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "Control"
    vpc_security_group_ids = [ "sg-053136960457e705c" ]
    tags = {
      Name = "Intro"
      Project = "Terraform"
    }
}