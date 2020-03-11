resource "aws_eks_cluster" "demo" {
  name     = var.cluster-name
  role_arn = aws_iam_role.demo-cluster.arn
  version  = "1.14"

  vpc_config {
    security_group_ids = [aws_security_group.demo-cluster.id]
    subnet_ids         = flatten([aws_subnet.demo.*.id])
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSServicePolicy,
  ]
}
