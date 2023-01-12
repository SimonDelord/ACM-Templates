These files are used to create a Policy on ACM that checks the GitOps operator against a specific version (channel in that case).
The demo goes like this:
- have 2 clusters on ACM one of them with the RedHat GitOps operator on channel 1.6, the other one with channel 1.7
- deploy the policy (matching on vendor = OpenShift) to check that GitOps should be using channel 1.7
- show that the policy gives one of the clusters with an error and the other one with compliant
- enforce the policy and show that the ArgoCD default instance (sitting in openshift-gitops) goes from version 2.4.14 (associated with channel 1.6) to 2.5.4 (to channel 1.7).
