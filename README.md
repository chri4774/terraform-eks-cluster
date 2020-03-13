# terraform-eks-cluster

## Ingress via Helm
helm install my-nginx stable/nginx-ingress --set rbac.create=true,service.enabled=false,controller.hostNetwork=true

## Test App
```
apiVersion: v1
kind: Namespace
metadata:
  name: tomcat

---
apiVersion: v1
kind: Service
metadata:
  name: tomcat
  namespace: tomcat
spec:
  ports:
  - name: http
    port: 80
    targetPort: 80
  selector:
    app: tomcat
    
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tomcat
  namespace: tomcat
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tomcat
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: tomcat
    spec:
      containers:
      - name: tomcat
        image: docker.io/library/nginx:latest
        ports:
        - name: http
          containerPort: 80
         
---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: tomcat-ingress
  namespace: tomcat
  #annotations:
  #  ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
   - host: foo.bar.com
     http:
      paths:
        - path: /
          backend:
            serviceName: tomcat
            servicePort: 80
```            