provider "aws" {
    access_key = "AKIA5HZJHPC27OV4ULWT"
    secret_key = "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"
    region     = "eu-central-1"
}


resource "aws_instance" "web" {
    ami           = "ami-0c960b947cbb2dd16"
    instance_type = "t3.micro"
}
