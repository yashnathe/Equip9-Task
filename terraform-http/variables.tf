variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-053b12d3152c0cc71"  # Modify with a valid AMI for your region
}
