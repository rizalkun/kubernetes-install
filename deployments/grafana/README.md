# Installation Grafana
Install Grafana Only or install prometheus + grafana.

Requirement.
- Kubernetes cluster
- Helm
## Grafana Only
```sh
git clone git@gitlab.com:candi1/be-ct.git
cd kubernetes-install/deployments/grafana
kubectl -f apply deployment.yaml
```
## Prometheus + Grafana

```sh
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

```

## Access dashboard of the grafana
```sh
kubectl port-forward deployment/prometheus-grafana 3000
```
Access: http://localhost:3000
Username: admin
Password: prom-operator
## Install Helm

```sh
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee
/etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```