#!/bin/bash -e
set -o pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

if [ -z "$SOUP_HOSTNAME" ]; then
    echo "Warning SOUP_HOSTNAME is not set so will be computed if possible."
    IS_CRC_DOMAIN=$(kubectl get ingresses.config.openshift.io cluster -o jsonpath={".spec.domain"})
    if [ "$IS_CRC_DOMAIN" == "apps-crc.testing" ]; then 
        export SOUP_HOSTNAME="env-boot-local-127-0-0-1.nip.io" 
        echo "On CRC, trying https:/$SOUP_HOSTNAME/hac/stonesoup"  
    else 
        export SOUP_HOSTNAME="hac.$IS_CRC_DOMAIN"  
        echo "Setting the target hostname to $SOUP_HOSTNAME based on the cluster domain."
        echo "If this name is not resolvable, you will need to set SOUP_HOSTNAME manually"
        echo "export SOUP_HOSTNAME=<your hostname>"   
        echo "Trying with $SOUP_HOSTNAME"
    fi 
    if nslookup  $SOUP_HOSTNAME  >/dev/null 2>&1; then
        echo "OK: $SOUP_HOSTNAME succeeds nslookup, proceeding with install"
    else 
        echo "Error: $SOUP_HOSTNAME fails nslookup, exiting because this install will not succeed"
        echo "If you want to uses this name regardless, run the following and re-run"
        echo "export SOUP_HOSTNAME=$SOUP_HOSTNAME"   
        exit
    fi
fi    


MY_GIT_FORK_REMOTE=origin 

MY_GIT_REPO_URL=$(git ls-remote --get-url $MY_GIT_FORK_REMOTE | sed 's|^git@github.com:|https://github.com/|')
MY_GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
trap "git checkout $MY_GIT_BRANCH" EXIT

if ! git diff --exit-code --quiet; then
    echo "Changes in working Git working tree, commit them or stash them"
    exit 1
fi

# Create preview branch for preview configuration
PREVIEW_BRANCH=preview-${MY_GIT_BRANCH}${TEST_BRANCH_ID+-$TEST_BRANCH_ID}
if git rev-parse --verify $PREVIEW_BRANCH &> /dev/null; then
    git branch -D $PREVIEW_BRANCH
fi
git checkout -b $PREVIEW_BRANCH

# this will change the apps to point to preview branch
$SCRIPTDIR/update-app-revisions
$SCRIPTDIR/update-sso.sh "$SOUP_HOSTNAME"

if ! git diff --exit-code --quiet; then
    git commit -a -m "Preview mode, do not merge into main"
    git push -f --set-upstream $MY_GIT_FORK_REMOTE $PREVIEW_BRANCH
fi
# this will update the app of apps 
$SCRIPTDIR/install_hac.sh  

# APPS=$(kubectl get apps -n openshift-gitops -o name) 
# REMOTE=$(git remote show origin -n | grep Fetch)
# REMOTE_ARR=($REMOTE)
# REMOTE=${REMOTE_ARR[2]} 
# # trigger refresh of apps
# for APP in $APPS; do
#   REPO=$(kubectl get  $APP -n openshift-gitops -o jsonpath="{.spec.source.repoURL}") 
#   if [ "$REPO" == "$REMOTE" ] 
#     then  
#         kubectl patch $APP -n openshift-gitops --type merge -p='{"metadata": {"annotations":{"argocd.argoproj.io/refresh": "hard"}}}' &
#     fi 
# done
# wait 

APPS=$(kubectl get apps -n openshift-gitops -o json) 
LEN=$(echo $APPS | jq .items | jq length)
REMOTE=$(git remote show origin -n | grep Fetch)
REMOTE_ARR=($REMOTE)
REMOTE=${REMOTE_ARR[2]}  
while true; do
    let LEN-- 
    ITEM=$(echo $APPS | jq -r ".items[$LEN]")   
    REPO=$(echo $ITEM | jq -r ".spec.source.repoURL")
    NAME=$(echo $ITEM | jq -r ".metadata.name") 
    if [ "$REPO" == "$REMOTE" ] 
    then    
        APP=$(kubectl get apps $NAME -n openshift-gitops -o name)
        kubectl patch $APP -n openshift-gitops --type merge -p='{"metadata": {"annotations":{"argocd.argoproj.io/refresh": "hard"}}}' & 
    fi  
    if [ "$LEN" == 0 ]; then 
        break
    fi
done 
wait 
   
echo  
echo "Find your soup at https:/$SOUP_HOSTNAME/hac/stonesoup"  