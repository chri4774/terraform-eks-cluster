# Create a new load balancer
resource "aws_elb" "this" {
  name               = "cselb"
  #availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  subnets = aws_subnet.demo[*].id
  security_groups = [ aws_security_group.elb_access.id, aws_security_group.demo-node.id ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
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

resource "aws_security_group" "elb_access" {
  name        = "elb_access"
  description = "Security group for elb_access from internet"
  vpc_id      = aws_vpc.demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.cluster-name}-elb_access"
  }
}

resource "aws_security_group_rule" "cs_eks_vpc_demo_ingress_http" {
  description              = "Allow http-access to nodes"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.elb_access.id
  cidr_blocks              = ["0.0.0.0/0"]
  to_port                  = 80
  type                     = "ingress"
}

resource "aws_security_group_rule" "cs_eks_vpc_demo-node-ingress-http" {
  description       = "Allow http-access to nodes"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.demo-node.id
  cidr_blocks       = [aws_vpc.demo.cidr_block]
  to_port           = 80
  type              = "ingress"
}


output "debug2" {
    value = aws_subnet.demo[*].id
}
