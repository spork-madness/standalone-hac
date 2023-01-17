#!/bin/bash  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..
# check out your own copy first and it will use it, instead of cloning a new one
CLOWDER=$ROOT/../clowder 
if [ -d $CLOWDER ]; then
  (cd $CLOWDER; ./build/kube_setup.sh)
else
  echo "No clowder found in $CLOWDER"
  echo "git clone https://github.com/RedHatInsights/clowder.git" 
  echo "into the parent directory ../clowder"
  echo "and re-reun this script"  
  exit 1
fi
  