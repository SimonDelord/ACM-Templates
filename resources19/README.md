# This repo is for ACM Observability on EKS clusters. #

The process is the following:
 - create an EKS cluster
 - deploy the EFS CSI operator on the EKS cluster
 - create an EFS file system
 - deploy Prometheus
 - import the cluster in ACM (and don't forget to add the observability component obviously).
 
 
## Build  a default EKS cluster ##

Eksctl create cluster –name XXXX –region XXXX

This will create all the required infra (VPC, Subnets, etc..) as well as 2 EC2 instances in a node-group.


## Then deploy the EFS driver ##
(Taken from https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)

create an IAM policy for EFS CSI Driver

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/docs/iam-policy-example.json

aws iam create-policy --policy-name AmazonEKS_EFS_CSI_Driver_Policy --policy-document file://iam-policy-example.json

eksctl utils associate-iam-oidc-provider --region=ap-southeast-1 --cluster=bendigo-cluster-5 --approve

eksctl create iamserviceaccount --cluster bendigo-cluster-5 --namespace kube-system --name efs-csi-controller-sa --attach-policy-arn arn:aws:iam::146616566043:policy/AmazonEKS_EFS_CSI_Driver_Policy --approve --region ap-southeast-1

Then deploy the efs driver 
(Taken from https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)

helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/

helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver     --namespace kube-system     --set image.repository=602401143452.dkr.ecr.eu-west-1.amazonaws.com/eks/aws-efs-csi-driver     --set controller.serviceAccount.create=false     --set controller.serviceAccount.name=efs-csi-controller-sa

(the image repository is available at https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html)

if for whatever reason, this doesn't work, you can always do another install using a deployment file

(taken from this https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html - under the install EFS driver section, select Manifest public-registry)

kubectl kustomize     "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.5" > public-ecr-driver.yaml

remove the top service Account from the public-ecr-driver.yaml file.

kubectl apply -f public-ecr-driver.yaml


## Now create an EFS environment for the EKS cluster ##

https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html (second half of the page - under To create an Amazon EFS file system for your Amazon EKS cluster)

vpc_id=$(aws eks describe-cluster --name bendigo-cluster-5 –region us-west-1 --query "cluster.resourcesVpcConfig.vpcId" --output text)

cidr_range=$(aws ec2 describe-vpcs --vpc-ids $vpc_id --query "Vpcs[].CidrBlock" --output text    --region us-west-1)

security_group_id=$(aws ec2 create-security-group --group-name MyEfsSecurityGroup     --description "My EFS security group" --vpc-id $vpc_id --output text –region us-west-1)

aws ec2 authorize-security-group-ingress --group-id $security_group_id --protocol tcp --port 2049 --cidr $cidr_range –region us-west-1

file_system_id=$(aws efs create-file-system --region us-west-1 --performance-mode generalPurpose --query 'FileSystemId' --output text)

aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" --query 'Subnets[*].{SubnetId: SubnetId,AvailabilityZone: AvailabilityZone,CidrBlock: CidrBlock}' --output table –region us-west-1

aws efs create-mount-target --file-system-id $file_system_id --subnet-id subnet-02cc06a5e6ebf13c2 --security-groups $security_group_id --region us-west-1

aws efs create-mount-target --file-system-id $file_system_id --subnet-id subnet-023e64953db361bf4 --security-groups $security_group_id --region us-west-1

aws efs create-mount-target --file-system-id $file_system_id --subnet-id subnet-013f28cba22259c3e --security-groups $security_group_id --region us-west-1

aws efs create-mount-target --file-system-id $file_system_id --subnet-id subnet-01e6f5bf83feefca3 --security-groups $security_group_id --region us-west-1


## Create an efs-sc storage class ##

the storage classe is the EFS-Storage-Class.yaml


## Configuring Prometheus on EKS ##
https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html

kubectl create namespace prometheus

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade -i prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="efs-sc",server.persistentVolume.storageClass="efs-sc"


