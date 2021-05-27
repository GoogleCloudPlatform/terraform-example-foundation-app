# Deploying Bank of Anthos
These instructions need to be run on the bastion host. To access the bastion host, open the Google Cloud console, and navigate to Compute Engine in the GKE project `prj-bu1-d-boa-gke`. Then, select the `gce-bastion-us-west1-b-01` and click on `ssh`. You need to be a whitelisted member to access this node which can be achieved either [manually](https://cloud.google.com/iap/docs/using-tcp-forwarding#grant-permission) or by adding your GCP User Identity in the list of `bastion_members` in `5-infrastructure/business_unit_1/<environment>/main.tf`

You can also connect to this instance by tunnelling SSH traffic through IAP.

    # Replace YOUR_PROJECT_ID with your GKE project ID.
    export GKE_PROJECT_ID=YOUR_PROJECT_ID
    gcloud compute ssh gce-bastion-us-west1-b-01 \
        --project ${GKE_PROJECT_ID} \
        --zone us-west1-b

## Install required tools

    sudo su
    yum update -y
    yum install git -y
    yum install google-cloud-sdk-kpt -y
    yum install jq -y
    yum install kubectl -y
    exit

## Pull the repo

    cd ${HOME}
    git clone https://github.com/GoogleCloudPlatform/terraform-example-foundation-app.git

## Define required environment variables
When indicated, make sure to replace the values below with the appropriate values based on the outcome of terraform.

    export GKE_PROJECT_ID=$(gcloud config get-value project)
    export PROJECT_NUM=$(gcloud projects describe ${GKE_PROJECT_ID} --format='value(projectNumber)')
    export CLUSTER_1=gke-1-boa-d-us-east1
    export CLUSTER_1_REGION=us-east1
    export CLUSTER_2=gke-2-boa-d-us-west1
    export CLUSTER_2_REGION=us-west1
    export CLUSTER_INGRESS=mci-boa-d-us-east1
    export CLUSTER_INGRESS_REGION=us-east1
    export WORKLOAD_POOL=${GKE_PROJECT_ID}.svc.id.goog
    export MESH_ID="proj-${PROJECT_NUM}"
    export ASM_VERSION=1.8
    export ISTIO_VERSION=1.8.3-asm.2
    export ASM_LABEL=asm-183-2
    export CTX_1=gke_${GKE_PROJECT_ID}_${CLUSTER_1_REGION}_${CLUSTER_1}
    export CTX_2=gke_${GKE_PROJECT_ID}_${CLUSTER_2_REGION}_${CLUSTER_2}
    export CTX_INGRESS=gke_${GKE_PROJECT_ID}_${CLUSTER_INGRESS_REGION}_${CLUSTER_INGRESS}
    export CICD_PROJECT_ID=YOUR_CICD_PROJECT_ID
    export SQL_PROJECT_ID=YOUR_SQL_PROJECT_ID
    export SQL_INSTANCE_NAME_EAST=YOUR_SQL_INSTANCE_NAME_EAST
    export SQL_INSTANCE_NAME_WEST=YOUR_SQL_INSTANCE_NAME_WEST

## Generate Kubeconfig Entries
In order to install ASM, we need to authenticate to clusters.

    gcloud container clusters get-credentials ${CLUSTER_1} --region ${CLUSTER_1_REGION}
    gcloud container clusters get-credentials ${CLUSTER_2} --region ${CLUSTER_2_REGION}
    gcloud container clusters get-credentials ${CLUSTER_INGRESS} --region ${CLUSTER_INGRESS_REGION}

## Install ASM
### Downloading the script

1. Download the version of the script that installs ASM 1.8.3.
    ```
    curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"${ASM_VERSION}" > install_asm
    ```

1. Make the script executable:
    ```
    chmod +x install_asm
    ```

1. Create a folder to host the installation files and asm packages. This folder will also include `istioctl`, sample apps, and manifests.
    ```
    mkdir -p ${HOME}/asm-${ASM_VERSION} && export PATH=$PATH:$HOME/asm-${ASM_VERSION}
    ```

### Install ASM on both clusters
The following commands run the script for a new installation of ASM on Cluster1 and Cluster2. By default, ASM uses Mesh CA. The `--enable_cluster_roles` flag allows the script to attempt to bind the service account running the script to the cluster-admin role on the cluster.

1. Install ASM on Cluster 1
    ```
    ./install_asm \
    --project_id ${GKE_PROJECT_ID} \
    --cluster_name ${CLUSTER_1} \
    --cluster_location ${CLUSTER_1_REGION} \
    --mode install \
    --output_dir ${HOME}/asm-${ASM_VERSION} \
    --enable_cluster_roles
    ```

1. Install ASM on cluster 2
    ```
    ./install_asm \
    --project_id ${GKE_PROJECT_ID} \
    --cluster_name ${CLUSTER_2} \
    --cluster_location ${CLUSTER_2_REGION} \
    --mode install \
    --enable_cluster_roles
    ```

### Configure endpoint discovery between clusters
We need to configure endpoint discovery for cross-cluster load balancing and communication.
1. Add ASM to your path:
    ```
    ./install_asm --version # get the version and then replace it in the below example
    # For version 1.8.5-asm.2 use the following command
    export PATH=$PATH:$HOME/asm-1.8/istio-1.8.5-asm.2/bin/
    ```

1. Creates a secret that grants access to the Kube API Server for cluster 1
    ```
    ./istioctl x create-remote-secret \
    --name=${CLUSTER_1} > secret-kubeconfig-${CLUSTER_1}.yaml
    ```

1. Apply the secret to cluster 2, so it can read service endpoints from cluster 1
    ```
    kubectl --context=${CTX_2} -n istio-system apply -f secret-kubeconfig-${CLUSTER_1}.yaml
    ```

1. In a similar manner, create a secret that grants access to the Kube API Server for cluster 2
    ```
    ./istioctl x create-remote-secret \
    --name=${CLUSTER_2} > secret-kubeconfig-${CLUSTER_2}.yaml
    ```

1. Apply the secret to cluster 1, so it can read service endpoints from cluster 2
    ```
    kubectl --context=${CTX_1} -n istio-system apply -f secret-kubeconfig-${CLUSTER_2}.yaml
    ```

## Register the Clusters to Anthos

1. Get cluster URIs for each cluster.
    ```
    export INGRESS_CONFIG_URI=$(gcloud container clusters list --uri | grep ${CLUSTER_INGRESS})
    export CLUSTER_1_URI=$(gcloud container clusters list --uri | grep ${CLUSTER_1})
    export CLUSTER_2_URI=$(gcloud container clusters list --uri | grep ${CLUSTER_2})
    ```

1. Register the clusters using workload identity.
    ```
    # Register the MCI cluster
    gcloud beta container hub memberships register ${CLUSTER_INGRESS} \
    --project=${GKE_PROJECT_ID} \
    --gke-uri=${INGRESS_CONFIG_URI} \
    --enable-workload-identity

    # Register cluster1
    gcloud container hub memberships register ${CLUSTER_1} \
    --project=${GKE_PROJECT_ID} \
    --gke-uri=${CLUSTER_1_URI} \
    --enable-workload-identity

    # Register cluster2
    gcloud container hub memberships register ${CLUSTER_2} \
    --project=${GKE_PROJECT_ID} \
    --gke-uri=${CLUSTER_2_URI} \
    --enable-workload-identity
    ```

## Enable and Setup Multi Cluster Ingress (MCI)
With MCI, we need to select a cluster to be the configuration cluster. In this case, `gke-mci-us-east1-001`. Once MCI is enabled, we can setup MCI. This entails establishing namespace sameness between the clusters, deploying the application in the clusters as preferred (in `gke-boa-us-east1-001` and `gke-boa-us-east1-001` clusters), and deploying a load balancer by deploying MultiClusterIngress and MultiClusterService resources in the config cluster

1. Enable MCI feature on config cluster
    ```
    gcloud alpha container hub ingress enable \
    --config-membership=projects/${GKE_PROJECT_ID}/locations/global/memberships/${CLUSTER_INGRESS}
    ```

1. Given that MCI will be used to loadbalance between the istio-gateways in east and west clusters, we need to create istio-system namespace in Ingress cluster to establish namespace sameness.
    ```
    kubectl --context ${CTX_INGRESS} create namespace istio-system
    ```

1. create a multi-cluster ingress
    ```
    cat <<EOF > ${HOME}/mci.yaml
    apiVersion: networking.gke.io/v1beta1
    kind: MultiClusterIngress
    metadata:
      name: istio-ingressgateway-multicluster-ingress
      annotations:
        networking.gke.io/static-ip: https://www.googleapis.com/compute/v1/projects/${GKE_PROJECT_ID}/global/addresses/mci-ip
        #networking.gke.io/pre-shared-certs: "boa-ssl-cert"
    spec:
      template:
        spec:
          backend:
            serviceName: istio-ingressgateway-multicluster-svc
            servicePort: 80
    EOF
    ```

1. create a multi-cluster service
    ```
    cat <<EOF > $HOME/mcs.yaml
    apiVersion: networking.gke.io/v1beta1
    kind: MultiClusterService
    metadata:
      name: istio-ingressgateway-multicluster-svc
      annotations:
        beta.cloud.google.com/backend-config: '{"ports": {"80":"gke-ingress-config"}}'
    spec:
      template:
        spec:
          selector:
            app: istio-ingressgateway
          ports:
          - name: frontend
            protocol: TCP
            port: 80 # servicePort defined in MCI
            targetPort: 8080 # port on the istio-ingressgateway pod req gets sent to (container port)
      clusters:
      - link: ${CLUSTER_1_REGION}/${CLUSTER_1}
      - link: ${CLUSTER_2_REGION}/${CLUSTER_2}
    EOF
    ```

Note: Make sure the environment variables in the mcs.yaml file are updated ${CLUSTER_1_REGION}, ${CLUSTER_1}, ${CLUSTER_2_REGION} and ${CLUSTER_2}

1. create a backend config
    ```
    cat <<EOF > $HOME/backendconfig.yaml
    apiVersion: cloud.google.com/v1beta1
    kind: BackendConfig
    metadata:
      name: gke-ingress-config
    spec:
      healthCheck:
        type: HTTP
        port: 8080
        requestPath: /ready
      securityPolicy:
        name: cloud-armor-xss-policy
    EOF
    ```
1. create the resources defined above.
    ```
    kubectl --context ${CTX_INGRESS} -n istio-system apply -f ${HOME}/backendconfig.yaml
    kubectl --context ${CTX_INGRESS} -n istio-system apply -f ${HOME}/mci.yaml
    kubectl --context ${CTX_INGRESS} -n istio-system apply -f ${HOME}/mcs.yaml
    ```

## Install and Configure ACM
### Generate a Private/Public Key Pairs
Generate a public/private key pairs, and then add the public key to the repo.
You will be presented with a message to specify the file location, just accept the default location `~/.ssh/id_rsa`.
Make sure to replace GIT_REPO_NAME with your username.

    ssh-keygen -t rsa -b 4096 \
    -C "GIT_REPO_USERNAME" \
    -N ''

Don't forget to upload the public key "~/.ssh/id_rsa.pub" to your repository. For cloud source repository, see [this link](https://cloud.google.com/source-repositories/docs/authentication)

### Create a Private Key
Create a secret with your private key in both clusters.

    ```
    kubectl create ns config-management-system --context ${CTX_1} && kubectl create secret generic git-creds --namespace=config-management-system --context ${CTX_1} --from-file=ssh="$HOME/.ssh/id_rsa"

    kubectl create ns config-management-system --context ${CTX_2} && kubectl create secret generic git-creds --namespace=config-management-system --context ${CTX_2} --from-file=ssh="$HOME/.ssh/id_rsa"
    ```

### Download and install ACM

    gsutil cp gs://config-management-release/released/1.7.0/config-management-operator.yaml config-management-operator.yaml

    kubectl apply --context=${CTX_1} -f config-management-operator.yaml
    kubectl apply --context=${CTX_2} -f config-management-operator.yaml

### Configure ACM

    kubectl apply --context=${CTX_1} -f ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-configs/config-management-east.yaml

    kubectl apply --context=${CTX_2} -f ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-configs/config-management-west.yaml

### Populate the CSR repos
For configuring and deploying the applicaiton, we are using multi-repo mode in ACM. This mode allows syncing from multiple repositories. In this excample, we have one root repository that hosts the cluster-wide and namespace-scoped configurations, and three namespace repositories to host the application manifests.

Find the Project ID for your CI/CD project (you can rerun `terraform output app_cicd_project_id` in the `gcp-projects/business_unit_1/shared` folder) It will look something like this: "prj-bu1-c-app-cicd-[RANDOM]"

1. Define an environment variable to set the project where the pipeline will run. Make sure to replace `YOUR_CICD_PROJECT_ID` with the appropriate project ID.
    ```
    export CICD_PROJECT_ID=YOUR_CICD_PROJECT_ID
    ```

2. create a new folder to host the content of your repositories, and navigate to that folder.
    ```
    mkdir ${HOME}/bank-of-anthos-repos && cd ${HOME}/bank-of-anthos-repos
    ```
#### root config repo
This repository is the root repository that host cluster-scoped and namespace-scoped configs for the bank of anthos application, such as resource policies, network polices and security policies.
1. Clone the `root-config-repo` that was created through the infrastructure pipeline
    ```
    gcloud source repos clone root-config-repo --project ${CICD_PROJECT_ID}
    ```

1. Copy the content of `acm-repos/root-config-repo` to `${HOME}/bank-of-anthos-repos/root-config-repo`
    ```
    cp -RT ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-repos/root-config-repo/ ${HOME}/bank-of-anthos-repos/root-config-repo
    ```

1. Move to the new folder
    ```
    cd ${HOME}/bank-of-anthos-repos/root-config-repo
    ```

1. Update the project name for the service account
replace the project id in the following files:

- "${HOME}/bank-of-anthos-repos/root-config-repo/namespaces/boa/accounts/accounts-sa.yaml"
- "${HOME}/bank-of-anthos-repos/root-config-repo/namespaces/boa/frontend/frontend-sa.yaml"
- "${HOME}/bank-of-anthos-repos/root-config-repo/namespaces/boa/transactions/transactions-sa.yaml"

You need to change this part to your GKE project:

- `GKE_PROJECT_ID`

1. Update the repository url for each namespace to point to the repository you cloned.

a. Replace CICD_PROJECT_ID with your project ID for the CICD pipeline
a. Replace the USER_EMAIL with your GCP cloud identity email address.
The changes need to be applied on the following files:

- ${HOME}/bank-of-anthos-repos/root-config-repo/namespaces/boa/accounts/repo-sync.yaml
- ${HOME}/bank-of-anthos-repos/root-config-repo/namespaces/boa/frontend/repo-sync.yaml
- ${HOME}/bank-of-anthos-repos/root-config-repo/namespaces/boa/transactions/repo-sync.yaml

1. push the content to the root-config-repo
    ```
    git add .
    git commit -m "adding config repo"
    git push origin master
    ```

#### accounts namespace
This repository will host the deployment and service manifests for `userservice` and `contacts` microservices.
1. Clone the `accounts` that was created through the infrastructure pipeline
    ```
    cd ${HOME}/bank-of-anthos-repos
    gcloud source repos clone accounts --project ${CICD_PROJECT_ID}
    ```

1. Copy the content of `acm-repos/accounts` to `${HOME}/accounts`
    ```
    cp -RT ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-repos/accounts/ ${HOME}/bank-of-anthos-repos/accounts
    ```

1. Move to the new folder
    ```
    cd ${HOME}/bank-of-anthos-repos/accounts
    ```

1. push the content to the accounts repo
    ```
    git add .
    git commit -m "adding accounts repo"
    git push origin master
    ```

#### frontend namespace
This repository will host the deployment and service manifests for `frontend` microservice, as well as a load generator service.
1. Clone the `frontend` that was created through the infrastructure pipeline
    ```
    cd ${HOME}/bank-of-anthos-repos
    gcloud source repos clone frontend --project ${CICD_PROJECT_ID}
    ```

1. Copy the content of `acm-repos/frontend` to `${HOME}/frontend`
    ```
    cp -RT ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-repos/frontend/ ${HOME}/bank-of-anthos-repos/frontend
    ```

1. Move to the new folder
    ```
    cd ${HOME}/bank-of-anthos-repos/frontend
    ```

1. push the content to the frontend repo
    ```
    git add .
    git commit -m "adding frontend repo"
    git push origin master
    ```

#### transactions namespace
This repository will host the deployment and service manifests for `transactionhistory`, `balancereader` and `ledgerwriter` microservices.
1. Clone the `transactions` that was created through the infrastructure pipeline
    ```
    cd ${HOME}/bank-of-anthos-repos
    gcloud source repos clone transactions --project ${CICD_PROJECT_ID}
    ```

1. Copy the content of `acm-repos/transactions` to `${HOME}/transactions`
    ```
    cp -RT ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-repos/transactions/ ${HOME}/bank-of-anthos-repos/transactions
    ```

1. Move to the new folder
    ```
    cd ${HOME}/bank-of-anthos-repos/transactions
    ```

1. push the content to the transactions repo
    ```
    git add .
    git commit -m "adding transactions repo"
    git push origin master
    ```

#### Configure syncing from the root repository
1. Update the repository url to point to your repository

a. Replace CICD_PROJECT_ID with your project ID for the CICD pipeline
a. Replace the USER_EMAIL with your GCP cloud identity email address.
The changes need to be applied on the following file:

- ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-configs/root-sync.yaml

1. apply the root-sync.yaml file.
    ```
    kubectl apply --context=${CTX_1} -f ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-configs/root-sync.yaml

    kubectl apply --context=${CTX_2} -f ${HOME}/terraform-example-foundation-app/6-anthos-install/acm-configs/root-sync.yaml
    ```

1. create private key secret in "accounts", "transactions" and "fronted" namespaces.
    ```
    # On Cluster 1
    kubectl create secret generic git-creds --namespace=transactions --context ${CTX_1} --from-file=ssh="${HOME}/.ssh/id_rsa"

    kubectl create secret generic git-creds --namespace=accounts --context ${CTX_1} --from-file=ssh="${HOME}/.ssh/id_rsa"

    kubectl create secret generic git-creds --namespace=frontend --context ${CTX_1} --from-file=ssh="${HOME}/.ssh/id_rsa"

    # On Cluster 2
    kubectl create secret generic git-creds --namespace=transactions --context ${CTX_2} --from-file=ssh="${HOME}/.ssh/id_rsa"

    kubectl create secret generic git-creds --namespace=accounts --context ${CTX_2} --from-file=ssh="${HOME}/.ssh/id_rsa"

    kubectl create secret generic git-creds --namespace=frontend --context ${CTX_2} --from-file=ssh="${HOME}/.ssh/id_rsa"
    ```

#### Required Updates
1. Provide a secret for the application to access CloudSQL.

Bank of Anthos uses two databases, one for the services in the accounts namespace and one for the services in the transactions namespace.

We will assume that the accounts database in the us-west1 region and the transactions database in the us-east1 region. You would need to get the instances' names, and the project ID.

    export SQL_PROJECT_ID=YOUR_SQL_PROJECT_ID
    export SQL_INSTANCE_NAME_EAST=YOUR_SQL_INSTANCE_NAME_EAST
    export SQL_INSTANCE_NAME_WEST=YOUR_SQL_INSTANCE_NAME_WEST

Example:

    export SQL_PROJECT_ID=prj-bu1-d-boa-sql-1aec
    export SQL_INSTANCE_NAME_EAST=boa-sql-1-d-us-east1-65de84c0
    export SQL_INSTANCE_NAME_WEST=boa-sql-2-d-us-west1-78a54a8f

1. create the CloudSQL secrets
    ```
    #Secret for accessing accounts db
    kubectl create secret generic cloud-sql-admin --context $CTX_1 --namespace=accounts --from-literal connectionName=$SQL_PROJECT_ID:us-west1:$SQL_INSTANCE_NAME_WEST --from-literal=username=admin --from-literal=password=admin

    kubectl create secret generic cloud-sql-admin --context $CTX_2 --namespace=accounts --from-literal connectionName=$SQL_PROJECT_ID:us-west1:$SQL_INSTANCE_NAME_WEST --from-literal=username=admin --from-literal=password=admin

    #Secret for accessing transactions db
    kubectl create secret generic cloud-sql-admin --context $CTX_1 --namespace=transactions --from-literal connectionName=$SQL_PROJECT_ID:us-east1:$SQL_INSTANCE_NAME_EAST --from-literal=username=admin --from-literal=password=admin

    kubectl create secret generic cloud-sql-admin --context $CTX_2 --namespace=transactions --from-literal connectionName=$SQL_PROJECT_ID:us-east1:$SQL_INSTANCE_NAME_EAST --from-literal=username=admin --from-literal=password=admin
    ```

1. Add IAM binding
    ```
    gcloud iam service-accounts add-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$GKE_PROJECT_ID.svc.id.goog[accounts/accounts]" \
    boa-gsa@$GKE_PROJECT_ID.iam.gserviceaccount.com

    gcloud iam service-accounts add-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$GKE_PROJECT_ID.svc.id.goog[transactions/transactions]" \
    boa-gsa@$GKE_PROJECT_ID.iam.gserviceaccount.com
    ```

1. Run script to populate database ledger
    ```
    kubectl apply -n transactions --context ${CTX_1} -f ${HOME}/terraform-example-foundation-app/6-anthos-install/db-scripts/populate-ledger-db.yaml
    ```

1. Run script to populate database accounts

    ```
    kubectl apply -n accounts --context ${CTX_2} -f ${HOME}/terraform-example-foundation-app/6-anthos-install/db-scripts/populate-accounts-db.yaml
    ```
