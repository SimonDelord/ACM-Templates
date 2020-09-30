cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: bookinfo
  labels:
    app: bookinfo  
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: bookinfo
  namespace: bookinfo
  labels:
    app: bookinfo
spec:
  type: GitHub
  pathname: https://github.com/SimonDelord/ACM-Templates.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: istio-clusters
  namespace: bookinfo
  labels:
    app: bookinfo 
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
  name: bookinfo
  namespace: bookinfo
  labels:
    app: bookinfo 
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
      - bookinfo
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: bookinfo
  namespace: bookinfo
  labels:
    app: bookinfo
  annotations:
      apps.open-cluster-management.io/github-path: resources4
spec:
  channel: bookinfo/bookinfo
  placement:
    placementRef:
      kind: PlacementRule
      name: istio-clusters
      apiGroup: apps.open-cluster-management.io     
EOF
