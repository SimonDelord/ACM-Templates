# ACM-Templates
Several templates for deploying apps using ACM

This is my first attempt at deploying an application via ACM onto multiple OCP and Kubernetes clusters.

The application is taken from Paul Bouwer "Hello-world Kubernetes image" https://github.com/paulbouwer/hello-kubernetes 

In the Resources folder, I have created three YAML files: 1/ Deployment for the application 2/ Service /3 Route

The acm-create.sh contains the YAML wrapper to associate this app to a channel / Subscription and Placement rule.

Simply login into the OCP environment that has the ACM operator deployed on it and run the acm-create.sh
