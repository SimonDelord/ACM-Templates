cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: default
  labels:
    app: default  
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: fortigate-vnf
  namespace: default
  labels:
    app: fortigate-vnf
spec:
  type: GitHub
  pathname: https://github.com/SimonDelord/ACM-Templates.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: cnv-clusters
  namespace: default
  labels:
    app: fortigate-vnf 
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions: []
    matchLabels:
      cnv: present
---
apiVersion: app.k8s.io/v1beta1
kind: Application
metadata:
  name: fortigate-vnf
  namespace: default
  labels:
    app: fortigate-vnf 
spec:
  componentKinds:
  - group: apps.open-cluster-management.io
    kind: Subscription
  descriptor: {}
  selector:
    matchExpressions:
    - key: app
      operator: In
      values:
      - fortigate-vnf
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: fortigate-vnf
  namespace: default
  labels:
    app: fortigate-vnf
  annotations:
      apps.open-cluster-management.io/github-path: resources6
spec:
  channel: default/fortigate-vnf
  placement:
    placementRef:
      kind: PlacementRule
      name: cnv-clusters
      apiGroup: apps.open-cluster-management.io     
EOF

