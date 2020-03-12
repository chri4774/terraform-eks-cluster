# Create a new load balancer
resource "aws_elb" "this" {
  name               = "cselb"
  #availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  subnets = aws_subnet.demo[*].id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "cs-elk-elb"
  }
}

resource "aws_autoscaling_attachment" "cs_eks_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.demo.id
  elb                    = aws_elb.this.id
}

resource "aws_security_group_rule" "cs_eks_vpc_demo_ingress_http" {
  description              = "Allow http-access to nodes"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.demo-node.id
  #cidr_blocks              = [aws_vpc.demo.cidr_block]
  cidr_blocks              = ["0.0.0.0/0"]
  to_port                  = 80
  type                     = "ingress"
}

output "debug2" {
    value = aws_subnet.demo[*].id
}
