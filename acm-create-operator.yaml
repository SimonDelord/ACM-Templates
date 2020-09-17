cat <<EOF | oc apply -f -
#apiVersion: v1
#kind: Namespace
#metadata:
#  name: openshift-operators
#  labels:
#    app: openshift-operators
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: operator-service-mesh
  namespace: openshift-operators
  labels:
    app: operator-service-mesh
spec:
  type: GitHub
  pathname: https://github.com/SimonDelord/ACM-Templates.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: operator-service-mesh
  namespace: openshift-operators
  labels:
    app: operator-service-mesh 
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
  name: operator-service-mesh
  namespace: openshift-operators
  labels:
    app: operator-service-mesh 
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
      - operator-service-mesh
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: operator-service-mesh
  namespace: openshift-operators
  labels:
    app: operator-service-mesh
  annotations:
      apps.open-cluster-management.io/github-path: resources3
spec:
  channel: openshift-operators/operator-service-mesh
  placement:
    placementRef:
      kind: PlacementRule
      name: operator-service-mesh
      apiGroup: apps.open-cluster-management.io     
EOF
