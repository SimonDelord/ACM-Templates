cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: simontest
  labels:
    app: simontest  
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: simontest
  namespace: simontest
  labels:
    app: simontest
spec:
  type: GitHub
  pathname: https://github.com/SimonDelord/ACM-Templates.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: dev-clusters
  namespace: simontest
  labels:
    app: simontest 
spec:
  clusterConditions:
  - status: "True"
    type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions: []
    matchLabels:
      environment: dev
---
apiVersion: app.k8s.io/v1beta1
kind: Application
metadata:
  name: simontest
  namespace: simontest
  labels:
    app: simontest 
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
      - simontest
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: simontest
  namespace: simontest
  labels:
    app: simontest
  annotations:
      apps.open-cluster-management.io/github-path: resources
spec:
  channel: simontest/simontest
  placement:
    placementRef:
      kind: PlacementRule
      name: dev-clusters
      apiGroup: apps.open-cluster-management.io     
EOF
