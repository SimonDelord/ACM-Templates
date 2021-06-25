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

Those are Resource folders for various VNF deployments. At the moment, I have played with Fortigate (from Fortinet) in Resource 6 and a service chaining scenario covering ,F5 LTM, Fortigate and Fedora VM in Resources 7.

### Resources 6

Resource 6 contains the YAML files for the deployment of a Fortigate VNF (single vNIC at this point). This requires the OpenShift Virtualisation Operator to work.

### Resources 7

It contains the YAML files for the deployment of the service-chaining demo. It contains an F5-LTM, a Fortigate and a Fedora VM. 
I am really grateful to Nabeel Cocker for helping out with the various YAML files for the F5-LTM.

In this demo, each VNF/VM is spun up with multiple network interfaces attached to various networks on the OCP cluster.
Each VNF/VM is also setup with a day-0 config (e.g initial config allowing network connectivity to the other VNFs/VMs and setup for accessing the management interface).
You may have to tweak your day0 config based on the specifics of your environments. 
For my demo I used an Hetzner server with nested virtualisation setup (e.g VMs running within VMs).

For the Fortigate I created an iso file for day 0 config (following those instructions - https://docs.fortinet.com/document/fortigate/6.0.0/fortigate-vm-on-kvm/767662/cloud-init). 
For both the Fedora VM and the F5-LTM I used the CloudInit capability that's part of OCP Virtualisation (E.g these are embedded in the YAML definition of the VMs and VNFs - see the YAML files under resources7).

I have exposed via routes both the Fortigate and the F5-LTM management interfaces.
This requires a some tweaking and a "more production like" solution would probably define an out of band network that management interfaces attach to rather than the standard PoD Network that I'm using. 
For the Fortigate I simply used port 80 (e.g http) while I used port 443 for the F5-LTM (there's a fair bit of tweaking there too in regards to setting up a route as a passthrough first and then a "reencrypt" method for the F5 self-signed CA). 

## Resources 8 for MachineAutoscaler and ClusterAutoscaler 
### Resources 8 

Resource 8 contains the various YAML files for the deployment of ClusterAutoscaler and MachineAutoscaler for a video/demo of ACM deploying those capabilities.

## Resources 9 for Deploying Operators using Policies (GRC section of ACM) 
### Resources 9

Resource 9 contains the YAML files for the deployment of the Operators required in Service Mesh (Elasticsearch, Kiali, Jaeger and ServiceMesh). But this time at the difference of using "Applications" for it, it is being done using Policies. Be careful on the use of OperatorGroup (if it's global scope, just don't include it in the ConfigurationPolicy as you will see it's greyed out). You can then reuse Resources 5 (for the Service Mesh MemberRoll and Control PLane setups) and Resource 4 for the book-info app.

