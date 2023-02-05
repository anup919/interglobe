
locals {
  inbound_ports = [80, 22]
}

resource "aws_security_group" "allow_tls" {
  name        = var.nsg
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpid
  
  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
       from_port = ingress.value
       to_port   = ingress.value
       protocol  = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
      }
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}



resource "aws_lb_target_group" "test" {
  name     = var.tgname
  port     = var.tgport
  protocol = var.tgprotocol
  vpc_id   = var.vpid
  health_check {
      healthy_threshold   = "3"
      interval            = "20"
      unhealthy_threshold = "2"
      timeout             = "10"
      path                = var.healthpath
      port                = "80"
}
}



resource "aws_lb" "test" {
  name               = var.albname
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = var.subnet[*]

  enable_deletion_protection = false


  tags = {
    Environment = "production"
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

output "apptarget" {
  value = aws_lb_target_group.test.arn
}

output "securityid" {
  value = aws_security_group.allow_tls.id

}

output "albarn" {
  value = aws_lb.test.arn
}

