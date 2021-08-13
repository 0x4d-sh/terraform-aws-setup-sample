variable "aws_cidr" {
    type = string
}

variable "aws_azs" {
    type = list(string)
}

variable "aws_prv_sub" {
    type = list(string)
}

variable "aws_pub_sub" {
    type = list(string)
}

variable "aws_proj_name" {
    type = string
}