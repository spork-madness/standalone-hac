
This is a gitops copy of the fronends from 

https://github.com/RedHatInsights/frontend-operator.git


This repo uses manifests directly where possible from the frontend-operator repo.

The environment.yaml is needed to map to custom sso.

For this stanalone hac, keycloak is provided by the infra-deployments install.
This ensures the toolchain and permission / rbac matches what is used in prod and can be tested as part of an install. 


