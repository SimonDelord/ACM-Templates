OK,
the  setup for the demo goes as per follows:

- create 2 OCP clusters
- deploy Submariner between these two clusters
- deploy AAP on one cluster
- create credentials on ACM to talk to AAP using an AAP token.

Next step is the first part of the demo:
- deploy the sample app (located in the sample-app folder) on one cluster. This app contains 3 tiers, a DB, a Backend and a frontend.
- export the backend service via submariner
- move the frontend to the second cluster
- check connectivity

Next step is the second part of the demo:
- create the data-locality policy on ACM
- create on AAP the project and templates associated with the policy violation
- add the AAP template to the ACM policy
- try and deploy the backend service to the second cluster


## 1st Step: Prepare the environment

All steps for the preparation of the environment are in the preparation folder.

### deploy submariner between the two clusters

Assuming both clusters have been deployed on AWS, it is just a matter of going through the clusterset setup and enabling GlobalNet as part of the deployment.


### deploy AAP on the local cluster

The AAP deployment can be done by hand by selecting the operator and then creating an instance, or another way is to define a policy for it.
The policy and the Controller Instance files are available under the preparation folder.

Simply type
oc apply -f AAP-Operator-Policy.yaml (this will create a policy that creates the aap namespace and deploys the AAP operator on the cluster).
oc apply -f Automation-Controller-Instance.yaml (this could be driven by an application from ACM).

### Create credentials on ACM to talk to AAP using an AAP token

Post AAP Controller install on the OCP cluster, there are a set of steps to follow.
If you're doing a default install, the admin password for AAP is within the aapexample-admin-password secret.

Log onto AAP and provide your credentials to get the relevant SKU.

Next create a Project to sync up your Ansible-playbooks as per the following
![Browser](https://github.com/SimonDelord/ACM-Templates/blob/master/resources12/images/ACM-ACS-Integration-photo2.png)

And once you've created the project, sync it up. Then create a template as per the following
![Browser](https://github.com/SimonDelord/ACM-Templates/blob/master/resources12/images/ACM-ACS-Integration-photo2.png)


1st part of the demo is to deploy
2 clusters 
Deploy Bryon’s app (https://github.com/bryonbaker/jboss-breakdown-monolith)
Check that it deploys ok
Move the frontend to another cluster (talk to Ben on how to change the service endpoint for it)
Move the middlebit to another cluster and get the deployment killed by ACM + AAP….



—-1st part of the demo—-----

Ok so I’ve deployed on the primary cluster:
Oc apply -f https://raw.githubusercontent.com/bryonbaker/jboss-breakdown-monolith/master/yaml/database-dep.yaml
Oc apply -f https://raw.githubusercontent.com/bryonbaker/jboss-breakdown-monolith/master/yaml/backend-dep.yaml
Oc apply -f https://raw.githubusercontent.com/bryonbaker/jboss-breakdown-monolith/master/yaml/backend-svc.yaml
Oc apply -f https://raw.githubusercontent.com/bryonbaker/jboss-breakdown-monolith/master/yaml/frontend-dep.yaml 

The app should then come up nicely. You can record one person in the app….
Then you should be able to create the same namespace on whatever remote cluster.
Oc new-project app-modernisation

Then you can apply the “updated” new frontend on the remote cluster
(file sitting under /home/ec2-user/Data-Location/ANZ-Bank-Tech-Talk/Bryon-app/frontend-dep.yaml)

The only difference in the file is

env:
        - name: BACKEND_PROVIDER_URL
          value: remote+http://backend.app-modernisation.svc.clusterset.local:8080

And then the frontend is able to go and retrieve the previous configured app.

—--2nd part of the demo—----
Deploy ansible operator
Create ansible instance
