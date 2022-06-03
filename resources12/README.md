This folder contains an ACM-ACS and compliance integration demo.
A video of the demonstration is available [here](https://youtu.be/s9Ll5PHPT-U).

These are the steps for the demo:

- step 1: ACM deploys the ACS operator on all clusters using a policy
- step 2: ACM deploys ACS Central on the Hub cluster (local-cluster) using an application
- step 3: ACM deploys ACS Central on the Hub cluster (local-cluster) using an application
- step 4: ACM deploys ACS Secured on all the clusters using applications
- step 5: ACM deploys the compliance operator on all clusters using a policy
- step 6: ACM gets the Compliance Operator to run a Scan for E8 and CIS using an application
- step 7: ACS displays the results of the initial Compliance Operator E8 / CIS scan

Steps currently not covered in the demo:
- ACM now changes the mode of Compliance Operator to "auto-fix"
- ACS displays the updated compliance statement



![Browser](https://github.com/SimonDelord/ACM-Templates/blob/master/resources12/images/ACM-ACS-Integration-photo1.png)
ACS deployment and configuration by ACM


The rest is template

This scenario is using an IPI install on AWS to setup a private OCP cluster in an existing VPC.
I have used the eu-west-2 region (London) to organise the AWS setup.

As part of the setup I created the following:
- one VPC
- 3 private subnets
- 3 public subnets
- 1 Elastic IP address
- one NAT Gateway
- 2 route tables associated with the VPC
- one Internet Gateway


I then generated a install-config.yaml file that can be used as the basis for the OCP cluster creation.

The OCP documentation for this is available https://docs.openshift.com/container-platform/4.8/installing/installing_aws/installing-aws-private.html#installation-custom-aws-vpc-requirements_installing-aws-private

However I struggled with the actual implementation of it (the AWS setup essentially).

These are the steps that need to be taken:
 - associate the internet gateway with the main Route Table in the VPC (rtb-00c310509fc11aafc) and add this internet gateway to a default route. Add the public subnets of the VPC to this route table (subnet association)
 - create the NAT Gateway (you could have up to 3 - e.g one per AZ) into one of the public subnets of the VPC (subnet-02861a246d9c51974 / vpc-ipi-public-a in this example) and associate the elastic IP address. In this example the NAT GW is 	nat-07b4ea1d8abb57d52
 - create a route table for the private subnets of the VPC (rtb-0bea709b735dd6377 in this example), add a default route to this route table and point it to the NAT Gateway created in the previous step (nat-07b4ea1d8abb57d52), associate the 3 private subnets to this route table. You could probably do 3 different private route tables, each one of them associated with a single private-subnet in the VPC and have a dedicated NAT Gateway in the AZ (e.g if you created 3 NAT GWs in the previous step).
 - The installer should now be able to be used as per the install-config.yaml file here

Here are the various screenshots and a diagram of the setup.

