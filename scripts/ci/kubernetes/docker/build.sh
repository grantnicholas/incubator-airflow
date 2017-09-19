IMAGE=grantnicholas/kubeairflow
TAG=${1:-latest}
DIRNAME=$(cd "$(dirname "$0")"; pwd)
AIRFLOW_ROOT="$DIRNAME/../../../.."

ENVCONFIG=$(minikube docker-env)
if [ $? -eq 0 ]; then
  eval $ENVCONFIG
fi

cd $AIRFLOW_ROOT && python setup.py sdist && cp $AIRFLOW_ROOT/dist/*.tar.gz $DIRNAME/airflow.tar.gz && \
cd $DIRNAME && docker build $DIRNAME --tag=${IMAGE}:${TAG}
