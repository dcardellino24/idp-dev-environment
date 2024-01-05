#!/bin/bash

# filepath=$(realpath "$1")
cluster_name=$1
location=$2
nodesize=$3
nodecount=$4

randomid=$(echo $RANDOM | md5sum | head -c 5)

filepath=infrastructure
#check if the cluster is already added
if [ -d "$filepath/$cluster_name" ] 
then
  echo "The cluster $cluster_name already exists."
else
  mkdir -p $filepath/$cluster_name
  cp -R $filepath/template/* $filepath/$cluster_name
  yq --inplace ".spec.project.id = \"${randomid}\"" $filepath/$cluster_name/cluster.yaml
fi

yq --inplace ".metadata.name = \"${cluster_name}\"" $filepath/$cluster_name/cluster.yaml
yq --inplace ".spec.environment = \"${cluster_name}\"" $filepath/$cluster_name/cluster.yaml
yq --inplace ".spec.location = \"${location}\"" $filepath/$cluster_name/cluster.yaml
yq --inplace ".spec.compositionSelector.matchLabels.cluster = \"${cluster_name}\"" $filepath/$cluster_name/cluster.yaml
yq --inplace ".spec.kubernetes.nodes.size = \"${nodesize}\"" $filepath/$cluster_name/cluster.yaml
yq --inplace ".spec.kubernetes.nodes.count = ${nodecount}" $filepath/$cluster_name/cluster.yaml


yq --inplace ".resources += [\"$cluster_name\"]" $filepath/kustomization.yaml