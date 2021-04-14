# Deploying Bank of Anthos 
These instructions need to be run on the bastion host. To access the bastion host, open the Google Cloud console, and navigate to Compute Engine in the GKE project. In my instance, `prj-bu1-d-boa-gke` Then, select the `gce-bastion-us-west1-b-01` and click on `ssh`. You need to be a whitelisted member to access this node.


## Insall required tools
```console
sudo su
yum install git
yum install google-cloud-sdk-kpt
yum install jq -y
sudo yum install kubectl
exit
```

## Pull the repo
```console
cd ${HOME}
git clone https://github.com/GoogleCloudPlatform/terraform-example-foundation-app.git
```

## Define required environment variables
When indicated, make sure to replace the values below with the appropriate values based on the outcome of terraform.
```console
# replace YOUR_PROJECT_ID with the project id for the project that will host your clusters.
# For example: prj-bu1-d-boa-gke-ecb0
export PROJECT_ID=YOUR_PROJECT_ID
export PROJECT_NUM=$(gcloud projects describe ${PROJECT_ID} --format='value(projectNumber)')
export CLUSTER_1=gke-boa-us-east1-001
export CLUSTER_1_REGION=us-east1
export CLUSTER_2=gke-boa-us-west1-001
export CLUSTER_2_REGION=us-west1
export CLUSTER_INGRESS=gke-mci-us-east1-001
export CLUSTER_INGRESS_REGION=us-east1
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUM}"
export ASM_VERSION=1.8
export ISTIO_VERSION=1.8.3-asm.2
export ASM_LABEL=asm-183-2
export CTX_1=$PROJECT_ID_$CLUSTER_1_REGION_CLUSTER_1
export CTX_2=$PROJECT_ID_$CLUSTER_2_REGION_CLUSTER_2
export CTX_INGRESS=$PROJECT_ID_$CLUSTER_INGRESS_REGION_CLUSTER_INGRESS
```
## Generate Kubeconfig Entries
In order to install ASM, we need to authenticate to clusters.

```console
gcloud container clusters get-credentials ${CLUSTER_1} --region ${CLUSTER_1_REGION}
gcloud container clusters get-credentials ${CLUSTER_2} --region ${CLUSTER_2_REGION}
gcloud container clusters get-credentials ${CLUSTER_INGRESS} --region ${CLUSTER_INGRESS_REGION}
```
## Install ASM
### Downloading the script

1. Download the version of the script that installs ASM 1.8.3.
```console
curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_"${ASM_VERSION}" > install_asm
```
2. Make the script executable:
```console
chmod +x install_asm
```
3. Create a folder to host the installation files and asm packages. This folder will also include `istioctl`, sample apps, and manifests.
```console
mkdir -p ${HOME}/asm-${ASM_VERSION} && export PATH=$PATH:$HOME/asm-${ASM_VERSION}
```

### Install ASM on both clusters
The following commands run the script for a new installation of ASM on Cluster1 and Cluster2. By default, ASM uses Mesh CA. The `--enable_all` flag will enable the required Google APIs and set IAM permissions.

1. Install ASM on Cluster 1
```console
./install_asm \
--project_id ${PROJECT_ID} \
--cluster_name ${CLUSTER_1} \
--cluster_location ${CLUSTER_1_REGION} \
--mode install \
--output_dir ${HOME}/asm-${ASM_VERSION} \
--enable_all
```

2. Install ASM on cluster 2

```console
./install_asm \
--project_id ${PROJECT_ID} \
--cluster_name ${CLUSTER_2} \
--cluster_location ${CLUSTER_2_REGION} \
--mode install \
--enable_all
```
### Configure endpoint discovery between clusters
We need to configure endpoint discovery for cross-cluster load balancing and communication. 
1. Creates a secret that grants access to the Kube API Server for cluster 1
```console
./istioctl x create-remote-secret \
--name=${CLUSTER_1} > secret-kubeconfig-${CLUSTER_1}.yaml
```
2. Apply the secret to cluster 2, so it can read service endpoints from cluster 1
```console
kubectl --context=${CTX_2} -n istio-system apply -f secret-kubeconfig-${CLUSTER_1}.yaml
```
3. In a similar manner, creates a secret that grants access to the Kube API Server for cluster 2 
```console
./istioctl x create-remote-secret \
--name=${CLUSTER_2} > secret-kubeconfig-${CLUSTER_2}.yaml
```
2. Apply the secret to cluster 1, so it can read service endpoints from cluster 2
```console
kubectl --context=${CTX_1} -n istio-system apply -f secret-kubeconfig-${CLUSTER_2}.yaml
``` 

## Register the Clusters to Anthos

1. Get cluster URIs for each cluster.

```console
export INGRESS_CONFIG_URI=$(gcloud container clusters list --uri | grep ${CLUSTER_INGRESS})
export CLUSTER_1_URI=$(gcloud container clusters list --uri | grep ${CLUSTER_1})
export CLUSTER_2_URI=$(gcloud container clusters list --uri | grep ${CLUSTER_2})
```

2. Register the clusters using workload identity.
```console
# Register the config cluster
gcloud beta container hub memberships register ${CLUSTER_INGRESS} \
--project=${PROJECT_ID} \
--gke-uri=${INGRESS_CONFIG_URI} \
--enable-workload-identity

# Register cluster1
gcloud container hub memberships register ${CLUSTER_1} \
--project=${PROJECT_ID} \
--gke-uri=${CLUSTER_1_URI} \
--enable-workload-identity

# Register cluster2
gcloud container hub memberships register ${CLUSTER_2} \
--project=${PROJECT_ID} \
--gke-uri=${CLUSTER_2_URI} \
--enable-workload-identity
```

## Enable and Setup Multi Cluster Ingress (MCI)
With MCI, we need to select a cluster to be the configuration cluster. In this case, `gke-mci-us-east1-001`. Once MCI is enabled, we can setup MCI. This entails establishing namespace sameness between the clusters, deploying the application in the clusters as preferred (in `gke-boa-us-east1-001` and `gke-boa-us-east1-001` clusters), and deploying a load balancer by deploying MultiClusterIngress and MultiClusterService resources in the config cluster 

1. Enable MCI feature on config cluster
```console
gcloud alpha container hub ingress enable \
--config-membership=projects/${PROJECT_ID}/locations/global/memberships/${CLUSTER_INGRESS}
```

2. Given that MCI will be used to loadbalance between the istio-gateways in east and west clusters, we need to create istio-system namespace in Ingress cluster to establish namespace sameness. 
```console
kubectl --context ${CTX_INGRESS} create namespace istio-system
```
3. create a multi-cluster ingress
```console
cat <<EOF > ${HOME}/mci.yaml
apiVersion: networking.gke.io/v1beta1
kind: MultiClusterIngress
metadata:
  name: istio-ingressgateway-multicluster-ingress
  annotations:
    networking.gke.io/static-ip: https://www.googleapis.com/compute/v1/projects/prj-bu1-d-boa-gke-ecb0/global/addresses/mci-ip
    networking.gke.io/pre-shared-certs: "boa-ssl-cert"
spec:
  template:
    spec:
      backend:
       serviceName: istio-ingressgateway-multicluster-svc
       servicePort: 80
EOF
```

4. create a multi-cluster service
```console
cat <<'EOF' > $HOME/mcs.yaml
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
  - link: "${CLUSTER_1_REGION}/${CLUSTER_1}"
  - link: "${CLUSTER_2_REGION}/${CLUSTER_2}"
EOF
```

5. create a backend config
```console
cat <<EOF > $HOME/backendconfig.yaml
apiVersion: cloud.google.com/v1beta1
kind: BackendConfig
metadata:
  name: gke-ingress-config
spec:
  healthCheck:
    type: HTTP
    port: 15020
    requestPath: /healthz/ready
  #securityPolicy:
   # Name: cloud-armor-xss-policy
EOF
```
6. create the resourced defined above.
```console
kubectl --context ${CTX_INGRESS} -n istio-system apply -f ${HOME}/backendconfig.yaml
kubectl --context ${CTX_INGRESS} -n istio-system apply -f ${HOME}/mci.yaml
kubectl --context ${CTX_INGRESS} -n istio-system apply -f ${HOME}/mcs.yaml
```

## Install and Configure ACM
## Create a Private Key
```console
kubectl create ns config-management-system --context ${CTX_1} && kubectl create secret generic git-creds --namespace=config-management-system --context ${CTX_1} --from-file=ssh="id_rsa.nomos"

kubectl create ns config-management-system --context ${CTX_2} && kubectl create secret generic git-creds --namespace=config-management-system --context ${CTX_2} --from-file=ssh="id_rsa.nomos"
```

### Download and install ACM

```console
gsutil cp gs://config-management-release/released/1.7.0/config-management-operator.yaml config-management-operator.yaml

kubectl apply --context=${CTX_1} -f config-management-operator.yaml
kubectl apply --context=${CTX_2} -f config-management-operator.yaml
```

### Configure ACM 
```console
kubectl apply --context=${CTX_1} -f ${HOME}/terraform-example-foundation-app/acm-configs/config-management-gke-east.yaml

kubectl apply --context=${CTX_2} -f ${HOME}/terraform-example-foundation-app/acm-config/config-management-gke-west.yaml
```

### Populate the CSR repos 
#### root config repo
1. Copy the content of `acm-repos/root-config-repo` to `${HOME}/root-config-repo`
```console
cd ${HOME}
cp ${HOME}/terraform-example-foundation-app/acm-repos/root-config-repo ${HOME}/root-config-repo
```

2. Move to the new folder
```console
cd ${HOME}/root-config-repo 
```
3. push the content to the root-config-repo

```console
gcloud source repos clone config-root-repo
git add .
git commit -m “adding config repo”
git push origin master
```
#### accounts namespace
1. Copy the content of `acm-repos/accounts` to `${HOME}/accounts`
```console
cd ${HOME}
cp ${HOME}/terraform-example-foundation-app/acm-repos/accounts ${HOME}/accounts
```

2. Move to the new folder
```console
cd ${HOME}/accounts
```
3. push the content to the accounts repo

```console
gcloud source repos clone accounts
git add .
git commit -m “adding accounts repo”
git push origin master
```
#### frontend namespace
1. Copy the content of `acm-repos/frontend` to `${HOME}/frontend`
```console
cd ${HOME}
cp ${HOME}/terraform-example-foundation-app/acm-repos/frontend ${HOME}/frontend
```

2. Move to the new folder
```console
cd ${HOME}/frontend
```
3. push the content to the frontend repo

```console
gcloud source repos clone frontend
git add .
git commit -m “adding frontend repo”
git push origin master
```

#### transactions namespace
1. Copy the content of `acm-repos/transactions` to `${HOME}/transactions`
```console
cd ${HOME}
cp ${HOME}/terraform-example-foundation-app/acm-repos/transactions ${HOME}/transactions
```

2. Move to the new folder
```console
cd ${HOME}/transactions
```
3. push the content to the transactions repo

```console
gcloud source repos clone transactions
git add .
git commit -m “adding transactions repo”
git push origin master
```
#### Configure syncing from the root repository
```console
kubectl apply --context=${CTX_1} -f ${HOME}/terraform-example-foundation-app/acm-configs/root-sync.yaml

kubectl apply --context=${CTX_2} -f ${HOME}/terraform-example-foundation-app/acm-config/root-sync.yaml
```

## Source Code Headers

Every file containing source code must include copyright and license
information. This includes any JS/CSS files that you might be serving out to
browsers. (This is to help well-intentioned people avoid accidental copying that
doesn't comply with the license.)

Apache header:

    Copyright 2021 Google LLC

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.