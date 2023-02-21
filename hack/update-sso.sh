#!/bin/bash  
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

# The hostname must be 
TARGET_HOSTNAME=$1  
if [[ -z "$TARGET_HOSTNAME" ]]; then
  echo "No hostname passed to update the FrontendEnvironment" 
  echo "This is likely because SOUP_HOSTNAME env variable not set" 
  exit 
fi

SSO_HOST_KEYCLOAK=$( kubectl get routes keycloak -n dev-sso  -o jsonpath={".spec.host"})
echo "HOSTNAME for AUTH is: $TARGET_HOSTNAME"
echo "KEYCLOAK AUTH is: $SSO_HOST_KEYCLOAK" 

cat << EOF > components/hac-boot/environment.yaml
apiVersion: cloud.redhat.com/v1alpha1
kind: FrontendEnvironment
metadata:
  name: env-boot
spec: 
# Use hack/update-sso.sh to compute this for dev-sso auth domain 
  sso: "https://$SSO_HOST_KEYCLOAK/auth/" 
  ingressClass: openshift-default
  hostname: $TARGET_HOSTNAME
EOF

echo "You need to commit this for it to take effect "