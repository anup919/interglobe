resource "aws_launch_template" "foo" {
  name_prefix = var.templatename

  image_id = var.imageid


  instance_market_options {
    market_type = "spot"
  }

  instance_type = var.instancetype


  key_name = var.keyname

  vpc_security_group_ids = [var.securitygroup]


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }
 user_data = filebase64("${path.module}/example.sh")
}
