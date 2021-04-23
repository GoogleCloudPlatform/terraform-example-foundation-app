# 5-infrastructure

The purpose of this step is to deploy the infrastructure for the Bank of Anthos Application using the infra pipeline setup in 4-projects.
a terraform code. There is also a [Source Repository](https://cloud.google.com/source-repositories) to push the code to be deployed.
All infrastructure components will be created using the base network created during step 3-networks to access private services.

## Components

- **3 GKE Clusters**
  - Cluster1 in the primary region (us-east1)
  - Cluster2 in the secondary region (us-west1)
  - MCI Cluster in the primary region (us-east1)
- **Bastion Host VM** in the secondary region (us-west1)
- **2 Postgres CLoudSQL instances** in the primary and secondary regions, respectively
- **Secret** to store the CloudSQL Admin Password
- **4 KMS Keyrings and Keys**
  - 2 KMS Keyrings and Keys for GKE, one in each region
  - 2 KMS Keyrings and Keys for CloudSQL, one in each region
- **Service Account for KMS** to own/manage the Keyrings and Keys
- **Service Account for the Bastion Host VM** with roles to install Anthos Service Mesh
- **4 Log Sinks**, one in each project
- **Log Sink Destination Storage Bucket** that Log Sinks write logs to
- **Cloud Armor Policy**
- **External IP** for accessing the application externally

## Prerequisites

1. [0-bootstrap](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/0-bootstrap/README.md) executed successfully.
1. [1-org](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/1-org/README.md) executed successfully.
1. [2-environments](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/2-environments/README.md) executed successfully.
1. [3-networks](../app-foundation/3-networks/README.md) executed successfully.
1. [4-projects](../app-foundation/4-projects/README.md) executed successfully.

## Usage

### Setup to run via Cloud Build
1. Clone repo `gcloud source repos clone boa-infra --project=prj-bu1-s-infra-pipeline-<random>`. (this is from the terraform output from the previous section, run `terraform output cloudbuild_project_id` in the `4-projects/business_unit_1/shared` folder)
1. Navigate into the repo `cd boa-infra`.
1. Change freshly cloned repo and change to non master branch `git checkout -b plan`.
1. Copy contents of foundation to new repo `cp -RT ../terraform-example-foundation-app/5-infrastructure/ .` (modify accordingly based on your current directory).
1. Copy cloud build configuration files for terraform `cp ../terraform-example-foundation-app/build/cloudbuild-tf-* . ` (modify accordingly based on your current directory).
1. Copy terraform wrapper script `cp ../terraform-example-foundation-app/build/tf-wrapper.sh . ` to the root of your new repository (modify accordingly based on your current directory).
1. Ensure wrapper script can be executed `chmod 755 ./tf-wrapper.sh`.
1. Rename `shared.auto.example.tfvars` to `shared.auto.tfvars` in business_unit_1/development folder and update the file with values from your environment and outputs from shared.
1. Rename `development.auto.example.tfvars` to `development.auto.tfvars` in business_unit_1/development folder and update the file with values from your environment and outputs from 4-projects/shared.
1. Rename `non-production.auto.example.tfvars` to `non-production.auto.tfvars` in business_unit_1/non-production folder and update the file with values from your environment and outputs from 4-projects/shared.
1. Rename `production.auto.example.tfvars` to `production.auto.tfvars` in business_unit_1/production folder and update the file with values from your environment and outputs from 4-projects/shared.
1. Commit changes with `git add .` and `git commit -m 'Your message'`.
1. When using Cloud Build or Jenkins as your CI/CD tool each environment corresponds to a branch is the repository for 5-app-infra step and only the corresponding environment is applied.
1. Push your plan branch to trigger a plan for all environments `git push --set-upstream origin plan` (the branch `plan` is not a special one. Any branch which name is different from `shared`, `development`, `non-production` or `production` will trigger a terraform plan).
    1. Review the plan output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to development with `git checkout -b shared` and `git push origin shared`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to development with `git checkout -b development` and `git push origin development`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to non-production with `git checkout -b non-production` and `git push origin non-production`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to production branch with `git checkout -b production` and `git push origin production`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID

### Run terraform locally (Alternate)
1. Change into `cd business_unit_1/shared` folder.
1. Run `cp ../../../tf-wrapper.sh .`
1. Run `chmod 755 tf-wrapper.sh`
1. Update backend.tf with your bucket from infra pipeline example. You can run
```for i in `find -name 'backend.tf'`; do sed -i 's/UPDATE_ME/<YOUR-BUCKET-NAME>/' $i; done```.
1. Run `terraform init`
1. Run `terraform plan`, this should report xx changes to be added if using the default config.
1. Run `terraform apply` ensure you have the correct permissions before doing this.

### Run cloudbuild dev/npd/prd envs

We will now deploy each of our environments(development/production/non-production) using this script.


**Troubleshooting:**
If your user does not have access to run the terraform modules locally and you are in the organization admins group, you can append `--impersonate-service-account="boa-terraform-<z>-sa@prj-bu1-<z>-boa-sec-<xxxx>.iam.gserviceaccount.com"` for dev/npd/prd envs or `--impersonate-service-account="cicd-build-sa@prj-bu1-s-app-cicd-<xxxx>.iam.gserviceaccount.com"` for shared env to run terraform modules as the service  account.

### TF Validate (Optional)
To use the `validate` option of the `tf-wrapper.sh` script, the latest version of `terraform-validator` must be [installed](https://github.com/forseti-security/policy-library/blob/master/docs/user_guide.md#how-to-use-terraform-validator) in your system and in you `PATH`.
1. Run `./tf-wrapper.sh init production`.
1. Run `./tf-wrapper.sh plan production` and review output.
1. Run `./tf-wrapper.sh validate production $(pwd)/../policy-library <YOUR_INFRA_PIPELINE_PROJECT>` and check for violations.
1. Run `./tf-wrapper.sh apply production`.
1. Run `./tf-wrapper.sh init non-production`.
1. Run `./tf-wrapper.sh plan non-production` and review output.
1. Run `./tf-wrapper.sh plan non-production` and review output.
1. Run `./tf-wrapper.sh validate non-production $(pwd)/../policy-library <YOUR_INFRA_PIPELINE_PROJECT>` and check for violations.
1. Run `./tf-wrapper.sh apply non-production`.
1. Run `./tf-wrapper.sh init development`.
1. Run `./tf-wrapper.sh plan development` and review output.
1. Run `./tf-wrapper.sh validate development $(pwd)/../policy-library <YOUR_INFRA_PIPELINE_PROJECT>` and check for violations.
1. Run `./tf-wrapper.sh apply development`.

If you received any errors or made any changes to the Terraform config or `terraform.tfvars` you must re-run `./tf-wrapper.sh plan <env>` before run `./tf-wrapper.sh apply <env>`.
