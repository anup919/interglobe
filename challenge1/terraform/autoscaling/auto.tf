
resource "aws_autoscaling_group" "bar" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier =  var.instance_subnet[*]
  target_group_arns = [var.tgarn]

  launch_template {
    id      = aws_launch_template.foo.id
    version = "$Latest"
  }
}
