
This is a gitops copy of the fronends from 

https://github.com/RedHatInsights/frontend-operator.git
 
This repo uses manifests directly where possible from the frontend-operator repo.

The environment.yaml is needed to map to custom sso.

For this stanalone hac, keycloak is provided by the infra-deployments install.
This ensures the toolchain and permission / rbac matches what is used in prod and can be tested as part of an install. 

hac-core, hac-dev and hac-infra are from the examples directory with updated image refs.

See https://github.com/RedHatInsights/frontend-operator
```
 quay.io/cloudservices/hac-core-frontend:xxxx referenced in: components/hac-boot/hac-core.yaml
 quay.io/cloudservices/hac-dev-frontend:xxxx referenced in: components/hac-boot/hac-dev.yaml
 quay.io/cloudservices/hac-infra-frontend:xxxx referenced in: components/hac-boot/hac-infra.yaml
 ```
 
run ./hack/show-current-images  to see what is being used




