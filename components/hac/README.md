
This is a gitops copy of the fronends from 

https://github.com/RedHatInsights/frontend-operator.git

The copy is to enable modification of the quay.io image used in 

```
 quay.io/cloudservices/hac-core-frontend:xxxx referenced in: components/hac/hac-core.yaml
 quay.io/cloudservices/hac-dev-frontend:xxxx referenced in: components/hac/hac-dev.yaml
 quay.io/cloudservices/hac-infra-frontend:xxxx referenced in: components/hac/hac-infra.yaml
 ```

run ./hack/show-current-images  to see what is being used

