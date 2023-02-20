#!/bin/bash  
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

if [ "$(oc auth can-i '*' '*' --all-namespaces)" != "yes" ]; then
  echo
  echo "[ERROR] User '$(oc whoami)' does not have the required 'cluster-admin' role." 1>&2
  echo "Log into the cluster with a user with the required privileges (e.g. kubeadmin) and retry."
  exit 1
fi

if [ -z "$DOMAIN" ]; then
    echo "Warning DOMAIN is not set so will be computed if possible."
    DOMAIN=$(kubectl get ingresses.config.openshift.io cluster -o jsonpath={".spec.domain"})
    if [ "$DOMAIN" == "apps-crc.testing" ]; then
      DOMAIN="env-boot-local-127-0-0-1.nip.io"
      echo "This install will be at https:/$DOMAIN/hac/stonesoup"  
    else 
      echo 
      echo "On external clusters, you must set DOMAIN prior to running the script."
      echo "This is your hostname that can be reached via a DNS lookup."
      exit
    fi  
fi

# update for clowder to ignore minikube 
export KUBECTL_CMD=kubectl
$SCRIPTDIR/install_clowder.sh  
$SCRIPTDIR/preview.sh  
$SCRIPTDIR/install_proxy.sh  
   
echo "This install will be at https:/$DOMAIN/hac/stonesoup"  
  