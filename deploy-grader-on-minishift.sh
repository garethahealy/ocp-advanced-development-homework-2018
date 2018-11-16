#!/usr/bin/env bash

export GUID=70b3
export USER=admin
export CLUSTER=192.168.64.5:8443
export REPO=https://github.com/garethahealy/ocp-advanced-development-homework-2018.git

oc login -u admin -p admin https://${CLUSTER}

./Infrastructure/bin/cleanup.sh ${GUID}
oc delete project $GUID-grading-jenkins

echo "Sleeping 30 seconds for project to be deleted"
sleep 30

./Infrastructure/bin/setup_projects.sh $GUID $USER

oc new-project $GUID-grading-jenkins

echo "Sleeping 30 seconds for project to be created"
sleep 30

oc process -f ansible/openshift-templates/jenkins/jenkins-persistent-template.yml | oc apply -n $GUID-grading-jenkins -f -

oc policy add-role-to-user admin system:serviceaccount:${GUID}-grading-jenkins:jenkins -n ${GUID}-jenkins
oc policy add-role-to-user admin system:serviceaccount:${GUID}-grading-jenkins:jenkins -n ${GUID}-nexus
oc policy add-role-to-user admin system:serviceaccount:${GUID}-grading-jenkins:jenkins -n ${GUID}-sonarqube
oc policy add-role-to-user admin system:serviceaccount:${GUID}-grading-jenkins:jenkins -n ${GUID}-parks-dev
oc policy add-role-to-user admin system:serviceaccount:${GUID}-grading-jenkins:jenkins -n ${GUID}-parks-prod

echo "Sleeping 4 minutes for jenkins to be created"
sleep 4m

oc process -f grading-build.yml -p GUID=$GUID -p USER=$USER -p CLUSTER=$CLUSTER -p REPO=$REPO | oc apply -n $GUID-grading-jenkins -f -

oc new-build -D $'FROM docker.io/openshift/jenkins-slave-maven-centos7:v3.11\n
      USER root\nRUN yum -y install skopeo ansible && yum clean all\n
      USER 1001' --name=jenkins-agent-appdev

echo "Sleeping 4 minutes for jenkins job to be created"
sleep 4m

oc start-build advdevhomeworkgrading --wait=true -n $GUID-grading-jenkins