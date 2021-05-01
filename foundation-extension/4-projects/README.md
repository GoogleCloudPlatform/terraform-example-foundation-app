# 4-projects

The purpose of this step is to set up a folder structure, projects, and infrastructure and application pipelines, which are connected as service projects to deploy an example application called Bank of Anthos.

## Prerequisites

1. [0-bootstrap](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/0-bootstrap/README.md) executed successfully.
1. [1-org](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/1-org/README.md) executed successfully.
1. [2-environments](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/2-environments/README.md) executed successfully.
1. [3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/README.md) executed successfully.

## Usage

### Setup to run via Cloud Build
1. Change directory to outside `terraform-example-foundation-app` using `cd ..`, to confirm you run `ls` and you should see `terraform-example-foundation-app` listed
1. Clone repo `gcloud source repos clone gcp-projects --project=YOUR_CLOUD_BUILD_PROJECT_ID`.
1. Change into freshly cloned repo `cd gcp-projects` and change to non master branch `git checkout -b plan` (the branch `plan` is not a special one. Any branch which name is different from `development`, `non-production` or `production` will trigger a terraform plan).
1. Copy example foundation to new repo `cp -RT ../terraform-example-foundation-app/foundation-extension/4-projects/ .` (modify accordingly based on your current directory).
1. Copy cloud build configuration files for terraform `cp ../terraform-example-foundation-app/build/cloudbuild-tf-* . ` (modify accordingly based on your current directory).
1. Copy terraform wrapper script `cp ../terraform-example-foundation-app/build/tf-wrapper.sh . ` to the root of your new repository (modify accordingly based on your current directory).
1. Ensure wrapper script can be executed `chmod 755 ./tf-wrapper.sh`.

### Run terraform locally
1. You will need to only once manually plan + apply the `shared` pipeline environments since `development`, `non-production` and `production` will depend on it.
1. Change into `business_unit_1/shared` folder.
1. Run `cp ../../tf-wrapper.sh .`
1. Run `chmod 755 tf-wrapper.sh`.
1. Rename `shared.auto.example.tfvars` to `shared.auto.tfvars` and update the file with values from your environment and bootstrap.
1. Update backend.tf with your bucket from example-foundation. You can run
```cd .. && for i in `find -name 'backend.tf'`; do sed -i 's/UPDATE_ME/<YOUR-BUCKET-NAME>/' $i; done && cd shared```.
1. Run `terraform init`
1. Run `terraform plan`
1. Run `terraform apply` ensure you have the correct permissions before doing this.

### Run cloudbuild dev/npd/prd envs
1. Go back to root folder `cd ../..`
1. Rename `mv business_unit_1/development/development.auto.example.tfvars business_unit_1/development/development.auto.tfvars` and update the file with values from your environment and outputs from 4-projects/shared.
1. Rename `mv business_unit_1/non-production/non-production.auto.example.tfvars business_unit_1/non-production/non-production.auto.tfvars` and update the file with values from your environment and outputs from 4-projects/shared.
1. Rename `mv business_unit_1/production/production.auto.example.tfvars business_unit_1/production/production.auto.tfvars` and update the file with values from your environment and outputs from 4-projects/shared.
1. Commit changes with `git add .` and `git commit -m 'Your message'`.
1. Push your plan branch to trigger a plan `git push --set-upstream origin plan` (the branch `plan` is not a special one. Any branch which name is different from `development`, `non-production` or `production` will trigger a terraform plan).
    1. Review the plan output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=prj-b-cicd-xxxx
1. Merge changes to development with `git checkout -b development` and `git push origin development`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=prj-b-cicd-xxxx
1. Merge changes to non-production with `git checkout -b non-production` and `git push origin non-production`.
    1. Review the apply output in your cloud build project. https://console.cloud.google.com/cloud-build/builds?project=prj-b-cicd-xxxx
1. Merge changes to production with `git checkout -b production` and `git push origin production`.
    1. Review the apply output in your cloud build project. https://console.cloud.google.com/cloud-build/builds?project=prj-b-cicd-xxxx

**Troubleshooting:**
If your user does not have access to run the terraform modules locally and you are in the organization admins group, you can append `--impersonate-service-account=org-terraform@prj-b-cicd-xxxx.iam.gserviceaccount.com` to run terraform modules as the service  account.

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
