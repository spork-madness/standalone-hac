#!/bin/bash  
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

if [ "$(oc auth can-i '*' '*' --all-namespaces)" != "yes" ]; then
  echo
  echo "[ERROR] User '$(oc whoami)' does not have the required 'cluster-admin' role." 1>&2
  echo "Log into the cluster with a user with the required privileges (e.g. kubeadmin) and retry."
  exit 1
fi

# update for clowder to ignore minikube 
export KUBECTL_CMD=kubectl
$SCRIPTDIR/install_clowder.sh  
$SCRIPTDIR/preview.sh  
$SCRIPTDIR/install_proxy.sh  
   
echo "This install will be at https:/$SOUP_HOSTNAME/hac/stonesoup"  
  