set -e 

IMAGE=${1:-grantnicholas/kubeairflow}
TAG=${2:-latest}
DIRNAME=$(cd "$(dirname "$0")"; pwd)

mkdir -p $DIRNAME/.generated
kubectl apply -f $DIRNAME/postgres.yaml
sed "s#{{docker_image}}#$IMAGE:$TAG#g" $DIRNAME/airflow.yaml.template > $DIRNAME/.generated/airflow.yaml && kubectl apply -f $DIRNAME/.generated/airflow.yaml


# wait for up to 5 minutes for everything to be deployed
for i in {1..150}
do
  echo "Running kubectl get pods:"
  echo "---------------------"
  PODS=$(kubectl get pods | awk 'NR>1 {print $0}')
  echo "$PODS"
  NUM_AIRFLOW_READY=$(echo $PODS | grep airflow | awk '{print $2}' | grep -E '([0-9])\/(\1)' | wc -l)
  NUM_POSTGRES_READY=$(echo $PODS | grep postgres | awk '{print $2}' | grep -E '([0-9])\/(\1)' | wc -l)
  if [ "$NUM_AIRFLOW_READY" == "1" ] && [ "$NUM_POSTGRES_READY" == "1" ]; then
    break
  fi
  sleep 2
done