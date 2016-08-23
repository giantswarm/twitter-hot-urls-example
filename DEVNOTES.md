
hpa

  https://github.com/kubernetes/kubernetes/blob/master/docs/proposals/custom-metrics.md
  https://github.com/kubernetes/kubernetes/blob/release-1.3/docs/proposals/custom-metrics.md
  https://github.com/kubernetes/kubernetes/blob/master/docs/design/horizontal-pod-autoscaler.md#horizontalpodautoscaler-object

  https://github.com/kubernetes/kubernetes/blob/release-1.3/docs/design/horizontal-pod-autoscaler.md


idea: add LivenessProbe, ReadinessProbe
  http://kubernetes.io/docs/user-guide/pod-states/#container-probes


---

idea for metrics:

- python script writes to /tmp/metrics in prometheus format
- container metrics-endpoint with static server
  caddy?



---
{
  cpu = "cpu00",
  id = "/docker/fe5564504fa8ff1a0b6e399e4af8ab77af6e8f2782c5891869ea18a229bd0767",
  image = "giantswarm/thux-resolver",
  instance = "minikubevm",
  io_kubernetes_container_hash = "f2378f68",
  io_kubernetes_container_name = "resolver",
  io_kubernetes_container_restartCount = "0",
  io_kubernetes_container_terminationMessagePath = "/dev/termination-log",
  io_kubernetes_pod_name = "resolver-1503533463-clsm7",
  io_kubernetes_pod_namespace = "thux",
  io_kubernetes_pod_terminationGracePeriod = "30",
  io_kubernetes_pod_uid = "587adccb-5fd5-11e6-a117-4e11ebaf17c6",
  job = "kubernetes-nodes",
  kubernetes_container_name = "resolver",
  kubernetes_namespace = "thux",
  kubernetes_pod_name = "resolver-1503533463-clsm7",
  name = "k8s_resolver.f2378f68_resolver-1503533463-clsm7_thux_587adccb-5fd5-11e6-a117-4e11ebaf17c6_e08ca3c2"
}




twitter rate limitting

  A good way to test a backoff implementation is to use invalid authorization credentials and examine the reconnect attempts. A good implementation will not get any 420 responses.

---


- [ ] use http://kubernetes.io/docs/user-guide/secrets/#service-accounts-automatically-create-and-attach-secrets-with-api-credentials
  for urlresolverscaler in kubernetes
---

kubectl create --filename kubernetes/inbox-redis-service.yaml
kubectl get --output wide services

kubectl create --filename kubernetes/inbox-redis-deployment.yaml
kubectl get deployments


kubectl create --filename kubernetes/rebrow-service.yaml
kubectl get --output wide services

kubectl create --filename kubernetes/rebrow-deployment.yaml
kubectl get deployments




kubectl delete deployments inbox-redis hotlist-redis frontend
kubectl delete services inbox-redis hotlist-redis frontend

kubectl delete deployments,services -l "app in (redis, guestbook)"


---

# Bring up Kubernetes

```bash

# weave
weave launch-router
weave launch-proxy --rewrite-inspect

# important (!)
weave expose -h (hostname).weave.local

# kubernetes
docker --host unix:///var/run/weave/weave.sock run --rm -ti \
  --volume /:/rootfs \
  --volume /var/run/weave/weave.sock:/docker.sock \
  weaveworks/kubernetes-anywhere:toolbox \
    sh -c 'setup-single-node'

docker --host unix:///var/run/weave/weave.sock run --rm -ti \
  --volume /:/rootfs \
  --volume /var/run/weave/weave.sock:/docker.sock \
  weaveworks/kubernetes-anywhere:toolbox \
    sh -c 'compose -p kube up -d'

kubectl cluster-info

# addons
docker --host unix:///var/run/weave/weave.sock run --rm -ti \
  --volume /:/rootfs \
  --volume /var/run/weave/weave.sock:/docker.sock \
  weaveworks/kubernetes-anywhere:toolbox \
    sh -c 'kubectl create -f addons.yaml'

# kubectl create \
#   -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/gce/coreos/kube-manifests/addons/dns/skydns-rc.yaml \
#   -f https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/gce/coreos/kube-manifests/addons/dns/skydns-svc.yaml


kubectl cluster-info

# dashboard
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
kubectl get --output wide --all-namespaces services

# use cluster-ip:port to connect

```

kubectl create secret generic --help

 # kubectl create secret generic tracker-secret --from-file=kubernetes/tracker-secret/

kubectl get secrets

kubectl create --filename kubernetes/
kubectl get --output wide services

kubectl exec --stdin --tty tracker-1349863666-4hfm2 bash


kubectl create --filename kubernetes/tracker-secret.yaml
kubectl create --filename kubernetes/


```bash
kubectl create --filename kubernetes/inbox-redis-service.yaml
kubectl create --filename kubernetes/inbox-redis-deployment.yaml

# optional
kubectl create --filename kubernetes/rebrow-service.yaml
kubectl create --filename kubernetes/rebrow-deployment.yaml

kubectl create --filename kubernetes/tracker-secret.yaml
kubectl create --filename kubernetes/tracker-deployment.yaml

# to stop the tracker use:
kubectl delete deployments/tracker

kubectl create --filename kubernetes/hotlist-redis-service.yaml
kubectl create --filename kubernetes/hotlist-redis-deployment.yaml

kubectl create --filename kubernetes/frontend-service.yaml
kubectl create --filename kubernetes/frontend-deployment.yaml


kubectl create --filename kubernetes/resolver-deployment.yaml

# optional
kubectl create --filename kubernetes/resolver-scaler-deployment.yaml

kubectl create --filename kubernetes/cleaner-deployment.yaml


```

kubectl get --output wide deployments,services,pods,secrets

kubectl delete deployments,services,secrets -l "app in (thux)"


# Prometheus

kubectl create --filename kubernetes-prometheus/configmap-2.yaml
kubectl create --filename kubernetes-prometheus/deployment.yaml
kubectl create --filename kubernetes-prometheus/


curl -v \
  --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
  -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  https://kubernetes/metrics


kubectl run grafana --image grafana/grafana --port=3000 --env="GF_SECURITY_ADMIN_PASSWORD=secret"
