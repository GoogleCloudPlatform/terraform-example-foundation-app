# 4-projects

The purpose of this step is to set up a folder structure, projects, and infrastructure and application pipelines, which are connected as service projects to deploy a modern application called The Bank of Anthos. These projects are created with Cloud Build triggers, CSRs for application infrastructure code, GCS buckets for state storage and follows the same [conventions](https://github.com/terraform-google-modules/terraform-example-foundation#branching-strategy) as the foundation pipeline deployed in [0-bootstrap](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/0-bootstrap/README.md). The cloudbuild SA used by this pipeline can impersonate the project SA by enabling the `enable_cloudbuild_deploy` flag and necessary roles can be granted to this SA via `sa_roles`. This pipeline can be utilized for deploying resources in projects across development/non-production/production with granular permissions.

## Prerequisites

1. [0-bootstrap](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/0-bootstrap/README.md) executed successfully.
1. [1-org](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/1-org/README.md) executed successfully.
1. [2-environments](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/2-environments/README.md) executed successfully.
1. [3-networks](https://github.com/terraform-google-modules/terraform-example-foundation/blob/master/3-networks/README.md) executed successfully.

**Troubleshooting:**
If your user does not have access to run the commands above and you are in the organization admins group, you can append `--impersonate-service-account=org-terraform@<SEED_PROJECT_ID>.iam.gserviceaccount.com` to run the command as the terraform service account.

## Usage
### Setup to run via Cloud Build
1. Clone repo `gcloud source repos clone gcp-projects --project=YOUR_CLOUD_BUILD_PROJECT_ID`.
1. Change freshly cloned repo and change to non master branch `git checkout -b plan` (the branch `plan` is not a special one. Any branch which name is different from `development`, `non-production` or `production` will trigger a terraform plan).
1. Copy example foundation to new repo `cp -R ../terraform-example-foundation/4-projects/ .` (modify accordingly based on your current directory).
1. Find and remove the example projects `find ../terraform-example-foundation/4-projects/ -type f -name example_*project.tf -exec ls {} \;` and change the `ls` to `rm` to remove the example project files.
1. Copy Bank of Anthos and pipeline projects to new repo `cp -R ../terraform-example-foundation-app/4-projects/ .` (modify accordingly based on your current directory).
1. Copy cloud build configuration files for terraform `cp ../terraform-example-foundation/build/cloudbuild-tf-* . ` (modify accordingly based on your current directory).
1. Copy terraform wrapper script `cp ../terraform-example-foundation/build/tf-wrapper.sh . ` to the root of your new repository (modify accordingly based on your current directory).
1. Ensure wrapper script can be executed `chmod 755 ./tf-wrapper.sh`.
1. Rename `common.auto.example.tfvars` to `common.auto.tfvars` and update the file with values from your environment and bootstrap.
1. Rename `development.auto.example.tfvars` to `development.auto.tfvars` and update the file with the `perimeter_name` that starts with `sp_d_shared_restricted`.
1. Rename `non-production.auto.example.tfvars` to `non-production.auto.tfvars` and update the file with the `perimeter_name` that starts with `sp_n_shared_restricted`.
1. Rename `production.auto.example.tfvars` to `production.auto.tfvars` and update the file with the `perimeter_name` that starts with `sp_p_shared_restricted`.
1. Commit changes with `git add .` and `git commit -m 'Your message'`.
1. You will need only once to manually plan + apply the `shared` pipeline environments since `development`, `non-production` and `production` will depend on it.
    1. cd to ./shared
    1. Update `backend.tf` with your bucket name from the bootstrap step.
    1. Run `terraform init`
    1. Run `terraform plan` and review output
    1. Run `terraform apply`
    1. If you would like the bucket to be replaced by cloud build at run time, change the bucket name back to `UPDATE_ME`
1. Push your plan branch to trigger a plan `git push --set-upstream origin plan` (the branch `plan` is not a special one. Any branch which name is different from `development`, `non-production` or `production` will trigger a terraform plan).
    1. Review the plan output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to production with `git checkout -b production` and `git push origin production`.
    1. Review the apply output in your cloud build project. https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to development with `git checkout -b development` and `git push origin development`.
    1. Review the apply output in your cloud build project https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
1. Merge changes to non-production with `git checkout -b non-production` and `git push origin non-production`.
    1. Review the apply output in your cloud build project. https://console.cloud.google.com/cloud-build/builds?project=YOUR_CLOUD_BUILD_PROJECT_ID
