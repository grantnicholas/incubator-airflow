DIRNAME=$(cd "$(dirname "$0")"; pwd)
AIRFLOW_ROOT="$DIRNAME/../.."
cd $AIRFLOW_ROOT && pip --version && ls -l $HOME/.wheelhouse && tox --version

if [ -z "$RUN_KUBE_INTEGRATION" ];
then
  tox -e $TOX_ENV
else
  $DIRNAME/kubernetes/setup_kubernetes.sh && \
  tox -e $TOX_ENV -- nosetests tests.contrib.executors.integration \
                     --with-coverage \
                     --cover-erase \
                     --cover-html \
                     --cover-package=airflow \
                     --cover-html-dir=airflow/www/static/coverage \
                     --with-ignore-docstrings \
                     --rednose \
                     --with-timer \
                     -v \
                     --logging-level=DEBUG
fi
