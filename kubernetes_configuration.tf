locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.demo-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}


# Connect kubectl to cluster:
# aws eks --region us-east-1 update-kubeconfig --name terraform-eks-demo

# - Run terraform output config_map_aws_auth and save the configuration into a file, e.g. config_map_aws_auth.yaml
# - Run kubectl apply -f config_map_aws_auth.yaml
# - You can verify the worker nodes are joining the cluster via: kubectl get nodes --watch
