data "aws_vpc" "default" {
  default = true
}

data "aws_vpc" "owner" {
  default = true
}

resource "aws_security_group_rule" "demo-node-ingress-ssh" {
  description       = "Allow ssh-access to nodes"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.demo-node.id
  cidr_blocks       = [data.aws_vpc.default.cidr_block]
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "demo-node-ingress-http" {
  description       = "Allow http-access to nodes"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.demo-node.id
  cidr_blocks       = [data.aws_vpc.default.cidr_block]
  to_port           = 80
  type              = "ingress"
}

resource "aws_vpc_peering_connection" "owner" {
  vpc_id        = data.aws_vpc.owner.id
  peer_vpc_id   = aws_vpc.demo.id
  auto_accept   = true
}

data "aws_route_tables" "accepter" {
  #provider = aws.accepter
  vpc_id = aws_vpc.demo.id 
} 

data "aws_route_tables" "owner" {
  vpc_id = data.aws_vpc.owner.id   
}

#output "debug1" {
#  value = sort(data.aws_route_tables.owner.ids)[count.index]
#}

resource "aws_route" "owner" {
  count = length(data.aws_route_tables.owner.ids)
  route_table_id = sort(data.aws_route_tables.owner.ids)[count.index]
  destination_cidr_block = aws_vpc.demo.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
}

resource "aws_route" "accepter" {
  #provider = aws.accepter
  count = length(data.aws_route_tables.accepter.ids)
  route_table_id = sort(data.aws_route_tables.accepter.ids)[count.index]
  destination_cidr_block = data.aws_vpc.owner.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
}
