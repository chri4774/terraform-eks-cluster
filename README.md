# terraform-eks-cluster

## Ingress via Helm
helm install my-nginx stable/nginx-ingress --set rbac.create=true,service.enabled=false,controller.hostNetwork=true