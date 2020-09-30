cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: istio-system
  labels:
    app: istio-system
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: istio-system
  namespace: istio-system
  labels:
    app: istio-system
spec:
  type: GitHub
  pathname: https://github.com/SimonDelord/ACM-Templates.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: istio-system
  namespace: istio-system
  labels:
    app: istio-system 
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
  name: istio-system
  namespace: istio-system
  labels:
    app: istio-system 
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
      - istio-system
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: istio-system
  namespace: istio-system
  labels:
    app: istio-system
  annotations:
      apps.open-cluster-management.io/github-path: resources5
spec:
  channel: istio-system/istio-system
  placement:
    placementRef:
      kind: PlacementRule
      name: istio-system
      apiGroup: apps.open-cluster-management.io     
EOF
