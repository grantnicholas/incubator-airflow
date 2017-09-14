IMAGE=grantnicholas/kubeairflow
TAG=${1:-latest}
DIRNAME=$(cd "$(dirname "$0")"; pwd)


if [ -f $DIRNAME/airflow.tar.gz ]; then
    echo "Not rebuilding airflow source"
else
    cd $DIRNAME/../ && python setup.py sdist && cd docker && \
    cp $DIRNAME/../dist/apache-airflow-1.9.0.dev0+incubating.tar.gz $DIRNAME/airflow.tar.gz
fi

eval $(sudo -E minikube docker-env) && docker build $DIRNAME --tag=${IMAGE}:${TAG}
