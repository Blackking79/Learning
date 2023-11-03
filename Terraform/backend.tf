terraform {
    backend "s3" {
        bucket = "kops1"
        key = "kops1/backend"
        region = "us-east-1"
    }
}