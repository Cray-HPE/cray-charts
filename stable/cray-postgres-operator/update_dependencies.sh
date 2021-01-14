#/bin/bash

# No need to re-run this script until you want to update the postgres-operator stored in this chart
# to a more recent version. Which shouldn't be a frequent thing, and is a manual operation really,
# we just have this script to help make it repeatable.

set -e

return_dir=$(pwd)
echo "Cloning https://github.com/zalando/postgres-operator"
if [ ! -d /tmp/postgres-operator ]; then
  git clone https://github.com/zalando/postgres-operator.git /tmp/postgres-operator
else
  cd /tmp/postgres-operator
  git pull origin master
  cd $return_dir
fi
rm -rf ./charts &> /dev/null || true
cd /tmp/postgres-operator
sha=$(git rev-parse --short HEAD)
cd $return_dir
cp -r /tmp/postgres-operator/charts ./

docker pull dtr.dev.cray.com/craypc/chartsutil:latest
chartsutil="docker run -it --rm -v $(pwd)/charts:/charts dtr.dev.cray.com/craypc/chartsutil:latest"
$chartsutil helm package /charts/postgres-operator -d /charts/
$chartsutil helm package /charts/postgres-operator-ui -d /charts/
sed -i.bak 's|^appVersion:.*$|appVersion: "'$sha'" # the postgres-operator repo sha|g' ./Chart.yaml
rm *.bak || true
rm -rf ./charts/postgres-operator
rm -rf ./charts/postgres-operator-ui
