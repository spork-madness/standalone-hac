#!/bin/bash  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

if [ "$(oc auth can-i '*' '*' --all-namespaces)" != "yes" ]; then
  echo
  echo "[ERROR] User '$(oc whoami)' does not have the required 'cluster-admin' role." 1>&2
  echo "Log into the cluster with a user with the required privileges (e.g. kubeadmin) and retry."
  exit 1
fi


if [ -n "$QUAY_IO_KUBESECRET" ]; then
    TMP_QUAY=$(mktemp)
    cp $QUAY_IO_KUBESECRET $TMP_QUAY
    yq e -i '.metadata.name = "quay-cloudservices-pull"' $TMP_QUAY
    if ! kubectl get namespace boot &>/dev/null; then
      kubectl create namespace boot
    fi
    if kubectl get secret quay-cloudservices-pull --namespace=boot &>/dev/null; then
      kubectl delete secret quay-cloudservices-pull --namespace=boot
    fi 
    kubectl create -f $TMP_QUAY --namespace=boot
    rm $TMP_QUAY
fi

kubectl apply -f $ROOT/argo-cd-apps/app-of-apps/all-applications.yaml