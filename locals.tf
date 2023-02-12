locals {
  my_function_source = "${var.lambda_file_directory}/package.zip"
  mandatory_tags = {
    env           = "sandbox",
    availability  = "private"
  }
}
