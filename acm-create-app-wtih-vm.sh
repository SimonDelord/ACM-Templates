cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: simonvm
  labels:
    app: simonvm  
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: simonvm
  namespace: simonvm
  labels:
    app: simonvm
spec:
  type: GitHub
  pathname: https://github.com/SimonDelord/ACM-Templates.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: cnv-clusters
  namespace: simonvm
  labels:
    app: simonvm 
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions: []
    matchLabels:
      environment: prod
---
apiVersion: app.k8s.io/v1beta1
kind: Application
metadata:
  name: simonvm
  namespace: simonvm
  labels:
    app: simonvm 
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
      - simonvm
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: simonvm
  namespace: simonvm
  labels:
    app: simonvm
  annotations:
      apps.open-cluster-management.io/github-path: resources2
spec:
  channel: simonvm/simonvm
  placement:
    placementRef:
      kind: PlacementRule
      name: cnv-clusters
      apiGroup: apps.open-cluster-management.io     
EOF
