variable region {
    default = "us-east-1"
}

variable zone1 {
    default = "us-east-1a" 
}

variable AMIS {
    type =  map
    default = {
        us-east-1 = "ami-0dbc3d7bc646e8516"
        us-east-2 = "ami-0a91cd140a1fc148a"
        us-west-1 = "ami-0a91cd140a1fc148a"
        us-west-2 = "ami-0a91cd140a1fc148a"
    }
}

variable user {
    default = "ec2-user"
}