# Build Bank of Anthos CICD App Pipeline

This is an opinionated repository demonstrating Cloud Build based builds of Bank-of-Anthos main-line along with secure CI/CD principles applied.
This demonstration uses Bank of Anthos to simulate a company building and deploying services to a multi-tier kubernetes cluster using asynchronous GitOps.

## Prerequisites

1. [0-bootstrap](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/0-bootstrap/README.md) executed successfully.
1. [1-org](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/1-org/README.md) executed successfully.
1. [2-environments](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/2-environments/README.md) executed successfully.
1. [3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/README.md) executed successfully.
1. [4-projects](../foundation-extension/4-projects/README.md) executed successfully.
1. [5-infrastructure](../5-infrastructure/README.md) executed successfully.
1. [Namespace repos created from 6-anthos-install](../6-anthos-install/README.md) created successfully.
   - frontend
   - accounts
   - transactions

## Setup to run via Cloud Build
1. Change directory to outside `terraform-example-foundation-app` using `cd ..`, to confirm you run `ls` and you should see `terraform-example-foundation-app` listed.
1. Clone Bank of Anthos repo.
   ```
   git clone https://github.com/GoogleCloudPlatform/bank-of-anthos.git
   ```
1. Delete the `.git` folder from the Github Bank of Anthos Repo.
   ```
   rm -rf bank-of-anthos/.git
   ```
1. Clone bank-of-anthos-source repo. Replace the Cloudbuild project id by the correct one (you can rerun `terraform output cloudbuild_project_id` in the `gcp-projects/business_unit_1/shared` folder)
   ```
   gcloud source repos clone bank-of-anthos-source --project=prj-bu1-c-app-cicd-<random>
   ```
1. Navigate into the repo.
   ```
   cd bank-of-anthos-source
   ```
1. Create main branch.
   ```
   git checkout -b main
   ```
1. Copy contents of Bank of Anthos Github Repo to new repo (modify accordingly based on your current directory).
   ```
   cp -RT ../bank-of-anthos .
   ```
1. Copy file `cloudbuild-build-boa.yaml` and `policies` folder from [7-app-build-deploy](.) to new repo (modify accordingly based on your current directory).
   ```
   cp -RT ../terraform-example-foundation-app/7-app-build-deploy .
   ```
1. Run the following command at the root folder level while replacing the region from `boa-infra/business_unit_1/shared` and project from `gcp-projects/business_unit_1/shared` stage.
   ```
   export REGION=<your_region>
   export PROJECT_ID=prj-bu1-c-app-cicd-<random>
   sed -i.bak \
      "s|gcr.io/bank-of-anthos|${REGION}-docker.pkg.dev/${PROJECT_ID}/${PROJECT_ID}-boa-image-repo|g" skaffold.yaml && \
      sed -i.bak "s|gitCommit: {}|sha256: {}|g" skaffold.yaml
   ```
1. Commit and push the changes.
   ```
   git add .
   git commit -m 'Your message'
   git push origin main
   ```
1. Cloudbuild will automatically run on push, confirm all stages of pipeline complete with a green check in https://console.cloud.google.com/cloud-build/builds?project=prj-bu1-c-app-cicd-xxxx
1. Check files mentioned in proceeding section have been changed in their respective repos (https://source.cloud.google.com/prj-bu1-c-app-cicd-xxxx).

## Files/Images edited by pipeline each run
```
prj-bu1-c-app-cicd-xxxx/
└── frontend
    ├── frontend.yaml
    ├── loadgenerator.yaml
└── accounts
    ├── contacts.yaml
    ├── userservice.yaml
└── transactions
    ├── balancereader.yaml
    ├── ledgerwriter.yaml
    ├── trasactionhistory.yaml
```

## Steps Performed

This is a diagram of the entire CI/CD flow with labeled stages. Each subsection (labeled as "phases") will target one or more of the subsections.

![image](https://user-images.githubusercontent.com/63249609/114470166-109bda00-9bb4-11eb-9997-204efbabbdc8.png)

### 1. Source Code and Image Creation
This first stage will build all candidate artifacts (docker-based images).

#### Steps
* Unit tests - Run unit tests for all source code
* Static code analysis (PMD, Checkstyle, Linting) - Run static analysis for all source code
* Secrets scanner - Look for secrets embedded in source
* Code coverage - Pull code coverage numbers and make decision based on results

#### Goals
* Fail fast if any of the steps fail
* Validate source code for artifact build

> NOTE: The conclusion of this stage will have all docker images created in the Artifact Repo or GAR. Additionally, an attestation will be created.

### 2. Artifact before deployment
This next stage is to verify the artifact before it has been deployed

#### Steps
* Container Structure Tests - Verify that the container built conforms to the organizational standards
* Container Analysis - Verify that the container does not contain Common Vulnerabilities or Exposures (CVEs) per the organization's standards

#### Goals
* Fail fast if any of the steps fail
* Validate the artifact build to be ready for lower-level environments
* Artifact passes basic organization policy regulations

### 3. Security Acceptance
The final phase is to create an Attestation to attest to the fact that the container has successfully completed the previous steps.

#### Steps
* Create Attestation - The only step in this phase is to create an attestation for the artifact. This requires the artifact's image-digest as well as access to the Actor/Signer for automated security.

#### Goals
* Create an attestation using the Security attestor

> **NOTE: Pipeline runs where image does not change / does not require a change will fail at the last step and is a postive failure**
