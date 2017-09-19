set -o xtrace
set -e

echo "This script downloads minikube, starts a driver=None minikube cluster, builds the airflow source and docker image, and then deploys airflow onto kubernetes"
echo "For development, start minikube yourself (ie: minikube start) then run this script as you probably do not want a driver=None minikube cluster"

DIRNAME=$(cd "$(dirname "$0")"; pwd)

$DIRNAME/minikube/start_minikube.sh
$DIRNAME/docker/build.sh
$DIRNAME/kube/deploy.sh

echo "Airflow environment on kubernetes is good to go!"
