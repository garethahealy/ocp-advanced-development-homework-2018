[![License](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

# ocp-advanced-development-homework-2018

## Running as a different user
- export GUID={opentlc guid}
- export USER={opentlc username}
- export CLUSTER={opentlc master api}

- oc login -u {username} -p {password} https://master.${CLUSTER}

- ./setup_projects.sh $GUID $USER
- ./setup_jenkins.sh $GUID 'repo' $CLUSTER
- ./setup_nexus.sh $GUID
- ./setup_sonar.sh $GUID

## Running as a gahealy
- ./deploy-as-gahealy