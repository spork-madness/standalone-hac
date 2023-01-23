# Standalone HAC

This repository installs a Stone Soup backend and a HAC UX frontend on a single cluster.

# Installation Steps

You will need a stanalone cluster (clusterbot or a large CRC) with kubeadmin 


1. Pre-Install infra-deployments https://github.com/redhat-appstudio/infra-deployments and wait til completion
2. Create a branch in your fork of this repo.
3. Secrets and config - You will need to create a directory `hack/commit`  (copy `./hack/no-commit-templates`).
You need credentials from your quay.io account in the correct formats and place these in the `commit` directory.
4. Customize this repository to have an environment with the correct keycloak instance
    `./hack/update-sso.sh`
5. Customize this repo to also point to your branch (gitops applications)
    `hack/update-app-revisions`

6. commit and publish your branch 

7. Run `./hack/install.sh` and it will install clowder, the applications and a proxy. 




 