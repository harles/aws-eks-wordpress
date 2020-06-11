# aws-eks-wordpress
This project will set up HA Wordpress when ready.  
Current status: troubles with provisioning eks cluster. Needs investigation.  
Manually components tested.  

## Provision resources
### Prerequisites
Have IAM user with sufficient privileges.  
Create 'sensitive.auto.tfvars' with following content (set your own credentials):  

access_key = "AWS_ACCESS_KEY"  
secret_key = "AWS_SECRET_KEY"  
db_master_username = "DB_MASTER_USERNAME"  
db_master_password = "DB_MASTER_PASSWORD"  

### Run
```{r}
$ terraform init  
$ terraform apply  
$ terraform destroy  
```

## Background information
Some sources to dig in in order to get high-level overview how to run HA Wordpress in aws
https://portworx.com/run-multi-tenant-wordpress-platform-amazon-eks/  
https://medium.com/@karl_31154/6-simple-steps-to-wordpress-high-availability-on-aws-b4a2d66ccdcd  
https://d0.awsstatic.com/whitepapers/wordpress-best-practices-on-aws.pdf  
https://github.com/aws-samples/aws-refarch-wordpress  

## Provisioning tool
Chosen tool: https://www.terraform.io/ because:
- supports several platforms
- has backend https://www.terraform.io/docs/backends/index.html
- supported resources and modules

Alternatives:
- https://aws.amazon.com/cloudformation/
- https://eksctl.io/

## Architecture
Following AWS services are used for the solution.

### Application
https://aws.amazon.com/eks/

Readings:  
https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster

IAM roles:  
nodes - AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy; trusted entity: ec2.amazonaws.com  
cluster - AmazonEKSClusterPolicy, AmazonEKSServicePolicy ; trusted entity: eks.amazonaws.com (role needed for cluster setup)  

### Fileshare
https://aws.amazon.com/efs/

Readings:  
https://containerjournal.com/topics/container-networking/using-ebs-and-efs-as-persistent-volume-in-kubernetes/
https://github.com/kubernetes-incubator/external-storage/tree/master/aws/efs
https://eksworkshop.com/beginner/190_efs/
https://github.com/brentwg/terraform-aws-efs
https://registry.terraform.io/modules/cloudposse/efs/aws/0.16.0

### Database
https://aws.amazon.com/rds/aurora/ - MySQL

Readings:  
https://aws.amazon.com/getting-started/hands-on/deploy-wordpress-with-amazon-rds/  
https://api.wordpress.org/secret-key/1.1/salt/  
https://github.com/terraform-aws-modules/terraform-aws-rds/tree/master/examples/complete-mysql  

### Network
https://aws.amazon.com/vpc/

Readings:  
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateVPC.html

## Open, not resolved topics
- [ ] eks provisioning not successful - nodes not connected
https://github.com/hashicorp/learn-terraform-provision-eks-cluster/issues/10
- [ ] how to create database user for application? (non-root)
- [ ] how to mount efs to eks nodes? (self-made ami?)
- [ ] consistent outputs
- [ ] README.md tuning
- [ ] define "least privilege" permissions for provisioning
