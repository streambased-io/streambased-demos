# Setup cluster

kind create cluster --config cluster/kind.yaml

# namespace

kubectl create namespace streambased-demo

# ingress

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
--for=condition=ready pod \
--selector=app.kubernetes.io/component=controller \
--timeout=90s

# create secrets

kubectl -n streambased-demo apply -f secrets/catalog-secret.yaml
kubectl -n streambased-demo apply -f secrets/config-secret.yaml

# start server

kubectl -n streambased-demo apply -f streambased_server/streambased-server.yaml

# verify with squirrel 

jdbc:trino://localhost:80

# superset

docker build -t streambased/superset-demo:latest superset_build
docker push streambased/superset-demo:latest

kubectl -n streambased-demo apply -f superset/superset.yaml

# verify in browser

localhost:80

new connection:

trino://streambased-server-service:8080/kafka/streambased