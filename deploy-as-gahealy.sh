#!/usr/bin/env bash

export GUID=70b3
export USER=gahealy-redhat.com
export CLUSTER=na39.openshift.opentlc.com
export REPO=https://github.com/garethahealy/ocp-advanced-development-homework-2018.git

./Infrastructure/bin/cleanup.sh $GUID

echo "Waiting for 30seconds for projects to fully terminate"
sleep 30s

oc get projects --show-all

./Infrastructure/bin/setup_projects.sh $GUID $USER

set -e

./Infrastructure/bin/setup_nexus.sh $GUID
./Infrastructure/bin/setup_sonar.sh $GUID
./Infrastructure/bin/setup_jenkins.sh $GUID $REPO $CLUSTER
./Infrastructure/bin/setup_dev.sh $GUID
./Infrastructure/bin/setup_prod.sh $GUID
./Infrastructure/bin/reset_prod.sh $GUID
