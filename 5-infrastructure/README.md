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
1. [3-networks](../foundation-extension/3-networks/README.md) executed successfully.
1. [4-projects](../foundation-extension/4-projects/README.md) executed successfully.

## Usage

### Setup to run via Cloud Build
1. Change directory to outside `terraform-example-foundation-app` using `cd ..`, to confirm you run `ls` and you should see `terraform-example-foundation-app` listed
1. Clone the policies repo. (This repo has the same name of the repo created in step 1-org but it is from a different project. We will clone with a different folder name to prevent a name collision).
   ```
   gcloud source repos clone gcp-policies gcp-policies-infra-pipeline --project=prj-bu1-c-infra-pipeline-<random>
   ```
1. Navigate into the repo.
   ```
   cd gcp-policies-infra-pipeline
   ```
1. Copy contents of policy-library to new repo.
   ```
   cp -RT ../terraform-example-foundation/policy-library/ .
   ```
1. Add the new allowed APIs to the end of the services list in the constraint `policies/constraints/serviceusage_allow_basic_apis.yaml`:
   ```
    - "binaryauthorization.googleapis.com"
    - "containeranalysis.googleapis.com"
   ```
1. Add the subnetwork CIDR ranges of the bastion host subnet and GKE Pods of each environment to the end of the authorized_networks list in the constraint `policies/constraints/gke_master_authorized_networks_enabled.yaml`:
   ```
    - 10.0.66.0/29
    - 100.64.72.0/22
    - 100.65.64.0/22
    - 10.0.130.0/29
    - 100.64.136.0/22
    - 100.65.128.0/22
    - 10.0.194.0/29
    - 100.64.200.0/22
    - 100.65.192.0/22
   ```
1. Remove constraint `gke_dashboard_disable.yaml` because [GKE dashboard](https://cloud.google.com/kubernetes-engine/docs/concepts/dashboards) is no longer installed by default and cannot be enable since version 1.15. It would rise a false positive.
   ```
   rm policies/constraints/gke_dashboard_disable.yaml
   ```
1. Disable constraint `gke_restrict_pod_traffic.yaml`. The network policies will be enable in step 6 and are not configured yet.
   ```
   mv policies/constraints/gke_restrict_pod_traffic.yaml policies/constraints/gke_restrict_pod_traffic.yaml_disabled
   ```
1. Commit changes.
   ```
   git add .
   git commit -m 'Your message'
   ```
1. Push your master branch to the new repo.
   ```
   git push --set-upstream origin master
   ```
1. Navigate out of the repo.
   ```
   cd ..
   ```
1. Clone repo `gcloud source repos clone boa-infra --project=prj-bu1-c-infra-pipeline-<random>`. (this is from the terraform output from the previous section, run `terraform output cloudbuild_project_id` in the `4-projects/business_unit_1/shared` folder)
1. Change into freshly cloned repo `cd boa-infra` and change to non master branch `git checkout -b plan`.
1. Copy contents of foundation to new repo `cp -RT ../terraform-example-foundation-app/5-infrastructure/ .` (modify accordingly based on your current directory).
1. Copy cloud build configuration files for terraform `cp ../terraform-example-foundation-app/build/cloudbuild-tf-* . ` (modify accordingly based on your current directory).
1. Copy terraform wrapper script `cp ../terraform-example-foundation-app/build/tf-wrapper.sh . ` to the root of your new repository (modify accordingly based on your current directory).
1. Ensure wrapper script can be executed `chmod 755 ./tf-wrapper.sh`.
1. Rename `mv business_unit_1/shared/shared.auto.example.tfvars business_unit_1/shared/shared.auto.tfvars` and update the file with values from your environment and outputs from 4-projects.
1. Rename `mv business_unit_1/development/development.auto.example.tfvars business_unit_1/development/development.auto.tfvars` and update the file with values from your environment and outputs from 4-projects.
1. Rename `mv business_unit_1/non-production/non-production.auto.example.tfvars business_unit_1/non-production/non-production.auto.tfvars` and update the file with values from your environment and outputs from 4-projects.
1. Rename `mv business_unit_1/production/production.auto.example.tfvars business_unit_1/production/production.auto.tfvars` and update the file with values from your environment and outputs from 4-projects.
1. Commit changes with `git add .` and `git commit -m 'Your message'`.
1. When using Cloud Build or Jenkins as your CI/CD tool each environment corresponds to a branch is the repository for 5-app-infra step and only the corresponding environment is applied.
1. Push your plan branch to trigger a plan for all environments `git push --set-upstream origin plan` (the branch `plan` is not a special one. Any branch which name is different from `shared`, `development`, `non-production` or `production` will trigger a terraform plan).
    1. Review the plan output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to plan with `git checkout -b shared` and `git push origin shared`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to development with `git checkout -b development` and `git push origin development`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to non-production with `git checkout -b non-production` and `git push origin non-production`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to production branch with `git checkout -b production` and `git push origin production`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
> **NOTE: If Terraform Apply Fails on any branch check Troubleshooting Section below**

### Run terraform locally (Alternate)
1. Change into `cd business_unit_1/shared` folder.
1. Run `cp ../../tf-wrapper.sh .`
1. Run `chmod 755 tf-wrapper.sh`
1. Update backend.tf with your bucket for infra pipeline can be found in `prj-bu1-c-infra-pipeline-<random>` and bucket should be `boa-infra-tfstate-<random>` if default config is used. You can run ```for i in `find -name 'backend.tf'`; do sed -i 's/UPDATE_ME/<YOUR-BUCKET-NAME>/' $i; done```.
1. Run `terraform init`
1. Run `terraform plan`
1. Run `terraform apply` ensure you have the correct permissions before doing this.

### Run cloudbuild dev/npd/prd envs

We will now deploy each of our environments(development/production/non-production) using this script.


### **Troubleshooting:**
#### Impersonate Error:
    - If your user does not have access to run the terraform modules locally and you are in the organization admins group, you can append `--impersonate-service-account="boa-terraform-<z>-sa@prj-bu1-<z>-boa-sec-<xxxx>.iam.gserviceaccount.com"` for dev/npd/prd envs or `--impersonate-service-account="cicd-build-sa@prj-bu1-c-app-cicd-<xxxx>.iam.gserviceaccount.com"` for shared env to run terraform modules as the service  account.
#### CloudSQL Error: (**`Error: Error waiting for Create Instance: on .terraform/modules/env.sql.boa_postgress_ha/modules/postgresql/read_replica.tf line 23, in resource "google_sql_database_instance" "replicas"`**)
    1. Clone repo `gcloud source repos clone boa-infra --project=prj-bu1-c-infra-pipeline-<random>` in Cloudshell and `git checkout <failed environment>`
    1. Change into directory for failed environment `cd business_unit_1/<failed environment>`
    1. Update backend.tf with your bucket for infra pipeline can be found in `prj-bu1-c-infra-pipeline-<random>` and bucket should be `boa-infra-tfstate-<random>` if default config is used. You can run ```for i in `find -name 'backend.tf'`; do sed -i 's/UPDATE_ME/<YOUR-BUCKET-NAME>/' $i; done```.
    1. Run `terraform init`
    1. Run `terraform state list | grep sql | grep replicas`, depending on the output go to GCP console https://console.cloud.google.com/sql/instances?q=search&referrer=search&project=prj-bu1-d-boa-sql-xxxx and manually delete the replicas that you **do not** see a state for.
    1. Note the SQL Intance Name (sql1 or sql2) for which you deleted replicas and head back to Cloudshell
    1. Run `terraform taint 'module.env.module.sql["sql1"].module.boa_postgress_ha.random_id.suffix[0]'` or `terraform taint 'module.env.module.sql["sql2"].module.boa_postgress_ha.random_id.suffix[0]'` according to the finding in previous step
    1. `git add -A && git commit -m 'SQL Deploy Error'` and `git push origin <failed environment>`

### TF Validate (Optional)
To use the `validate` option of the `tf-wrapper.sh` script, please follow the [instructions](https://github.com/forseti-security/policy-library/blob/master/docs/user_guide.md#install-terraform-validator) in the **Install Terraform Validator** section and install version `2021-03-22` in your system. You will also need to rename the binary from `terraform-validator-<your-platform>` to `terraform-validator` and the `terraform-validator` binary must be in your `PATH`.
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
