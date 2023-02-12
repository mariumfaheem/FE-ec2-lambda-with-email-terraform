variable "lambda_s3_bucket" {
  type    = string
  default = "aws-lambda-jobs-bucket"  #Give name it will cr
}

variable "name" {
  type    = string
  default = "ec2_with_sg_email"
}
variable "bucket_key" {
  type = string
  default = "ec2_alerting_scripts"
}

variable "cron_schedule_enforce_bucket_encryption" {
  type = string
  default = "rate(1 day)"
}

variable "description" {
  type = string
  default = ""
}
variable "lambda_file_name" {
  type = string
  default =  "ec2_with_sg_email"
}

variable "runtime" {
  type = string
  default = "python3.9"
}

variable "lambda_file_directory" {
  type = string
  default = "source"
}


variable "sender" {
  type    = string
  default = "mariums82@gmail.com"
}

variable "receiver" {
  type    = string
  default = "mariums82@gmail.com"
}
variable "password" {
  type = string
}

variable "region" {
  type = string
}
variable "rmd_cyber_security" {
  type = string
}
variable "vpc_id" {
  type = string
}