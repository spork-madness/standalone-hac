#!/bin/bash  
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"  
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

SSO_HOST_KEYCLOAK=$( kubectl get routes keycloak -n dev-sso  -o jsonpath={".spec.host"})
DOMAIN=$(kubectl  get ingresses.config.openshift.io cluster -o jsonpath={".spec.domain"})
echo "DOMAIN AUTH is: $SSO_HOST_KEYCLOAK"
echo "KEYCLOAK AUTH is: $SSO_HOST_KEYCLOAK"

if [ "$DOMAIN" == "apps-crc.testing"]; then
  DOMAIN="env-boot-local-127-0-0-1.nip.io"
fi 

cat << EOF > components/hac-boot/environments
apiVersion: cloud.redhat.com/v1alpha1
kind: FrontendEnvironment
metadata:
  name: env-boot
spec: 
  sso: "https://$SSO_HOST_KEYCLOAK/auth/" 
  ingressClass: openshift-default
  hostname: $DOMAIN
EOF

echo "You need to commit this for it to take effect "