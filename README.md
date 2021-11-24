# omniscient-devops-test
Hello World application deployed onto EKS, with period health check script. 

You can access the Hello World application via the ELB DNS name at a7a350f9da27e4ec98d9489ce1842421-316934250.ap-southeast-2.elb.amazonaws.com/hello

The health check script is located at health_check.py. You can run it locally with the following command:
`python health_check.py`

## Overview
The application is running on a kubernetes cluster (EKS) and exposed to the world by a classic load balancer. 

You will find the infrastructure as code used to provision the cluster and associated resources inside the `infra` directory. Kubernetes manifests are located within `k8s`, and the python Flask application along with associated unit tests can be found under the `src` directory.

I used GitHub Actions to implement CI and CD. Check out the workflow yaml files inside the `.github/workflows` directory. Here you will find two separate pipelines; one validates and deploys the Terraform infrastructure and applies the base kubectl manifests such the Deployment and Service kubernetes objects, the other runs linting and unit tests on the web application source code, builds it into a docker image, pushes to a private repository, then performs a rolling update of the kubernetes Deployment with the newly built docker image.


## How to make this solution more production ready / What I would do if I had more time
* For continuous delivery, my pipeline currently executes a `kubectl apply -f k8s/` after building the docker image, which deploys all of the kubernetes resources within the k8s directory. This approach does not scale well as tool usage grows, and can be difficult to manage. A better approach would be to implement a declarative GitOps tool such as ArgoCD or FluxCD to handle the continuous delivery.
* Reserve system resources for kubelet to ensure that application pods don't consume all of the nodes memory
* Implement some monitoring around business SLI's. Metrics can be gathered with Prometheus which you can use to build informational dashboards with Grafana. Some good metrics to monitor for include:
    - latency (90th, 95th, 99th percentile request/response times)
    - errors (2xx,3xx,4xx,5xx)
    - traffic/throughput (requests per second)
    - saturation (cpu,memory,disk IO of nodes and containers)
* Standardise application deployments amongst teams through the use of helm charts
* Implement an IngressController and ingress resources to handle routing to internal services rather than a classic load balancer
* Node and container logs should be shipped off the worker nodes to a centralised location like CloudWatch or Sumologic. 
* Implement cluster autoscaler to scale worker nodes based on resource usage.
* Implement Horizontal Pod Autoscaler to scale deployments on the application bottleneck 
* Add liveness and readiness probes to application pods to ensure application is always up and running. If probe fails, K8s kills the pod and deploys a new one.
* Create a hosted zone in Amazon Route53 with an A record pointing to the load balancer
* Increase security
    - SSL certificate on the load balancer (currently serving http only on port 80) with a HTTPS redirect, implement end-to-end encryption if required. 
    - Add IAM roles for service accounts to implement least privilege for application pods [1].
    - Kubernetes security contexts, network policies, psp's
    - VPC gateway endpoint for ECR in order to pull down images over a private network.
* Cost optimizations
    - Implement spot instances or savings plans
    - Set approriate requests and limits on containers

## Resources
[1] https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html