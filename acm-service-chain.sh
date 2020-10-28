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
  name: service-chain
  namespace: default
  labels:
    app: service-chain
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
    app: service-chain 
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
  name: service-chain
  namespace: default
  labels:
    app: service-chain 
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
      - service-chain
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: service-chain
  namespace: default
  labels:
    app: service-chain
  annotations:
      apps.open-cluster-management.io/github-path: resources7
spec:
  channel: default/service-chain
  placement:
    placementRef:
      kind: PlacementRule
      name: cnv-clusters
      apiGroup: apps.open-cluster-management.io     
EOF

