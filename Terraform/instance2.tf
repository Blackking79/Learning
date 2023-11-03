resource "aws_key_pair" "SSH" {
    key_name = "SSH"
    public_key = file("SSH.pub")
}

resource "aws_instance" "intro" {
    ami = var.AMIS[var.region]
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = aws_key_pair.SSH.key_name
    vpc_security_group_ids = [ "sg-053136960457e705c" ]
    tags = {
      Name = "Intro"
      Project = "Terraform"
    }

    provisioner "file" {
        source = "web.sh"
        destination = "/tmp/web.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/web.sh",
            "sudo /tmp/web.sh"
        ]
    }

    connection {
        user = var.user
        private_key = file("SSH")
        host = self.public_ip
    }
}

output pubicIP {
    value = aws_instance.intro.public_ip
}

output privateIP {
    value = aws_instance.intro.private_ip
}