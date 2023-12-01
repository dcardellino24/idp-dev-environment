#!/bin/bash

NAME=$1
PROVIDER=$2
CLUSTER=$3
NODE_SIZE=$4

FILE_PATH=infrastructure/${NAME}

if [ ! -d $FILE_PATH ]
then
  mkdir -p $FILE_PATH
  cp crossplane/cluster-template.yaml $FILE_PATH/cluster.yaml
else
  cp crossplane/cluster-template.yaml $FILE_PATH/cluster.yaml
fi

yq --inplace ".metadata.name = \"${NAME}-$(cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9' | fold -w 5 | head -n 1)\"" $FILE_PATH/cluster.yaml
yq --inplace ".spec.id = \"${NAME}\"" $FILE_PATH/cluster.yaml
yq --inplace ".spec.compositionSelector.matchLabels.provider = \"${PROVIDER}\"" $FILE_PATH/cluster.yaml
yq --inplace ".spec.compositionSelector.matchLabels.cluster = \"${CLUSTER}\"" $FILE_PATH/cluster.yaml
yq --inplace ".spec.parameters.nodeSize = \"${NODE_SIZE}\"" $FILE_PATH/cluster.yaml

