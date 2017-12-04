#!/bin/bash
set -eu
cwd=$(cd $(dirname $0);pwd)
cd ${cwd}

# If there is no current context, get one.
if [[ $(kubectl config current-context 2> /dev/null) == "" ]]; then
    cluster=$(gcloud config get-value container/cluster 2> /dev/null)
    zone=$(gcloud config get-value compute/zone 2> /dev/null)
    project=$(gcloud config get-value core/project 2> /dev/null)

    function var_usage() {
        cat <<EOF
No cluster is set. To set the cluster (and the zone where it is found), set the environment variables
  CLOUDSDK_COMPUTE_ZONE=<cluster zone>
  CLOUDSDK_CONTAINER_CLUSTER=<cluster name>
EOF
        exit 1
    }

    [[ -z "$cluster" ]] && var_usage
    [[ -z "$zone" ]] && var_usage

    echo "Running: gcloud container clusters get-credentials --project=\"$project\" --zone=\"$zone\" \"$cluster\""
    gcloud container clusters get-credentials --project="$project" --zone="$zone" "$cluster" || exit
fi

echo version: ${1}
cat ./template.yaml | sed s#{tag}#$1# > ./my-api-$1.yaml
cat ./my-api-$1.yaml

kubectl apply -f ./my-api-$1.yaml