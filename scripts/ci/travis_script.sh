DIRNAME=$(cd "$(dirname "$0")"; pwd)
AIRFLOW_ROOT="$DIRNAME/../../.."
cd $AIRFLOW_ROOT

if [ -z "$RUN_KUBE_INTEGRATION" ];
then
  pip --version && ls -l $HOME/.wheelhouse && tox --version && tox -e $TOX_ENV
else
  $DIRNAME/kubernetes/setup_kubernetes.sh && nosetests tests.contrib.executors.integration
fi
