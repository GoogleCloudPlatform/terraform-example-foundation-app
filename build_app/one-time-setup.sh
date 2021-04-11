#!/bin/bash
BUILD_BUILDER_IMG="false"
CREATE_CACHES="false"
FIRST_RUN="${FIRST_RUN:-true}" # Default to true, but allow override
WORKSHOP_MODE="${WORKSHOP_MODE:-false}"

if [[ -z "${PROJECT_ID}" ]]; then
    echo "Please set environment variable 'PROJECT_ID' to the Google project ID"
    exit 1
fi

if [[ "${FIRST_RUN}" == "true" ]]; then
    # Enable services for BinAuthZ
    gcloud --project="${PROJECT_ID}" services enable \
      cloudbuild.googleapis.com \
      container.googleapis.com \
      containeranalysis.googleapis.com \
      containerregistry.googleapis.com \
      binaryauthorization.googleapis.com

    PROJECT_NUMBER="$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)")"
    # Set permissions for CloudBuild agent to view attestations
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
      --member serviceAccount:"${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
      --role roles/binaryauthorization.attestorsViewer
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
      --member serviceAccount:"${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
      --role roles/editor
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
      --member serviceAccount:"${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
      --role roles/secretmanager.admin
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
      --member serviceAccount:"${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
      --role roles/containeranalysis.ServiceAgent

    # Make sure cloudbuild has been enabled and GCS bucket for sources exists
    HAS_CLOUDBUILD=$(gsutil ls -al "gs://${PROJECT_ID}_cloudbuild" > /dev/null 2>&1)
    # shellcheck disable=SC2181
    if [[ $? -gt 0 ]]; then
        echo "CloudBuild service does not appear to be enabled."
        exit 1
    fi

    # create_attestor
fi

# Create cache folders IF they don't exist
# Setting up the cache
if [[ "${FIRST_RUN}" == "true" ]] || [[ "${CREATE_CACHES}" == "true" ]]; then
    BUCKET="gs://${PROJECT_ID}_cloudbuild/cache"
    CACHES=("/.m2" "/.skaffold" "/.cache/pip/wheels")
    for CACHE in "${CACHES[@]}"; do
        # shellcheck disable=SC2034
        HAS_CLOUDBUILD=$(gsutil ls -al "${BUCKET}${CACHE}" > /dev/null 2>&1)
        # shellcheck disable=SC2181
        if [[ $? -gt 0 ]]; then
            touch .ignore
            echo "Creating cache folder ${BUCKET}${CACHE}/.ignore"
            gsutil cp .ignore "${BUCKET}${CACHE}/.ignore"
            rm -rf .ignore
        fi
    done
fi

# create new build image for CloudBuild stages
if [[ "${FIRST_RUN}" == "true" ]] || [[ "${BUILD_BUILDER_IMG}" == "true" ]]; then
    pushd cloud-build-builder || exit
        gcloud builds submit --config cloudbuild-skaffold-build-image.yaml --project="${PROJECT_ID}"
    popd || exit
fi

# Backup readme
BACKUP_FILES=("README.md" ".gitignore")
for FILE in "${BACKUP_FILES[@]}"; do
    cp "$FILE" "$FILE".bak
done
# Pull down mainline Bank of Anthos over the top of this project
curl -Lo bank-of-anthos.zip https://github.com/GoogleCloudPlatform/bank-of-anthos/archive/master.zip
unzip bank-of-anthos.zip
mv bank-of-anthos-master/{.[!.],}* .
rm -rf bank-of-anthos-master
# Restore overlapping files
for FILE in "${BACKUP_FILES[@]}"; do
    # shellcheck disable=SC2086
    mv "$FILE.bak" $FILE
done

############ SETUP COMPLETE ################

# At this point in the script, the Bank of Anthos has been pulled in and the pipeline can start
# Run the Cloud Build pipeline
if [[ "${WORKSHOP_MODE}" == "false" ]]; then
    # for local development of this workshop
    sed -i "s|gcr.io/bank-of-anthos|gcr.io/$PROJECT_ID|g" skaffold.yaml
    # Switch to sha256 based image tags instead of git SHAs
    sed -i "s|gitCommit: {}|sha256: {}|g" skaffold.yaml

    gcloud builds submit --project="${PROJECT_ID}"
fi
