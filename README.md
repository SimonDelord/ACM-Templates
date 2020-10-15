# ACM-Templates
These various Resources folders contain all the templates I have used for deploying apps using RHACM.

The various Resources folders contain the YAML files with the various apps / config files.
The acm-create.sh files then contain the various RHACM files for Namespaces, Channels, Subscriptions, Placement Rules & Applications wrapped into a single file:
- acm-create.sh : RHACM YAML files for Resources (deployment of hello-world app)
- acm-create-app-with-vm.sh: RHACM YAML files for Resources2 (deployment of hybrid app running VM + Container)
- acm-create-operator.sh: RHACM YAML files for Resources3 (deployment of a group of Operators (Service-Mesh & dependencies))
- acm-create-meshcontrolplane.sh: RHACM YAML files for Resources5 (configuration of the Service-mesh operator - control plane & members)
- acm-create-istio-app-bookinfo.sh: RHACM YAML files for Resources4 (deployment of Istio sample bookinfo app)

### Resources

This is my first attempt at deploying an application via ACM onto multiple OCP and Kubernetes clusters.

The application is taken from Paul Bouwer "Hello-world Kubernetes image" https://github.com/paulbouwer/hello-kubernetes 

In the Resources folder, I have created three YAML files: 1/ Deployment for the application 2/ Service /3 Route

The acm-create.sh contains the YAML wrapper to associate this app to a channel / Subscription and Placement rule.

Simply login into the OCP environment that has the ACM operator deployed on it and run the acm-create.sh


### Resources2

This is for an hybrid deployment (VM + Container) via RHACM. It requires the OpenShift virtualisation Operator on the platform to work

## Resources 3,4 and 5 are used for the Istio Book-info App deployment 

Resources 3 is used for the deployment of the various Operators for Service-mesh

Resource 4 is the actual Istio app - book-info (Istio sample application available in https://istio.io/latest/docs/examples/bookinfo/)

Resource 5 is the configuration of the Service-mesh Operator 

The logical steps are then to deploy:
- Resources3
- Resources5
- Resources4

### Resources3

Contains the YAML files for the deployment of the various operators required for the Service-mesh (the Elasticsearch Operator is not included there but can be easily added).

### Resources4

Contains the YAML files for the deployment of the Istio sample application book-info

### Resources5

Contains the YAML files for the configuration of the Istio Operator
- basic-install.yaml : is the ServiceMesh control plane configuration in the istio-system namespace
- ServiceMeshMemberRoll.yaml: is the members (namespaces) to which the Service Mesh Control Plane is applied to.

## Resources 6 & 7 are used for VNF deployments

Those are Resource folders for various VNF deployments. At the moment, I have played with Fortigate (from Fortinet) in Resource 6 and F5 LTM in Resource 7.

### Resources 6

Resource 6 contains the YAML files for the deployment of a Fortigate VNF (single vNIC at this point). This requires the OpenShift Virtualisation Operator to work.

### Resources 7

It contains the YAML for the deployment of an F5-LTM. I am really grateful to Nabeel Cocker for helping out with the various YAML files for this VNF.
