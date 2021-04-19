# Overview

This is an opinionated repository demonstrating Cloud Build based builds of Bank-of-Anthos main-line along with secure CI/CD principles applied.

This demonstration uses Bank of Anthos to simulate a company building and deploying services to a multi-tier kubernetes cluster using asynchronous GitOps.

# Requirements

1. Clone Bank of Anthos Repo into `bank-of-anthos-source` Cloud Source Repo in project `prj-bu1-s-app-cicd-xxxx` under folder `fldr-common`
1. Copy in files `cloudbuild-build-boa.yaml` and `policies` folder into above repo
1. Run `sed -i.bak "s|gcr.io/bank-of-anthos|$_DEFAULT_REGION-docker.pkg.dev/$PROJECT_ID/$_GAR_REPOSITORY|g" skaffold.yaml` and `sed -i.bak "s|gitCommit: {}|sha256: {}|g" skaffold.yaml` at the root folder level while replacing the variables with the outputs obtained from runnning 5-infrastructure/business-unit-1/shared

# Run the Demo

This is a diagram of the entire CI/CD flow with labeled stages. Each subsection (labeled as "phases") will target one or more of the subsections.

![image](https://user-images.githubusercontent.com/63249609/114470166-109bda00-9bb4-11eb-9997-204efbabbdc8.png)

## 1. Source Code
This first stage will build all candidate artifacts (docker-based images).

![image](https://user-images.githubusercontent.com/63249609/114470317-4b057700-9bb4-11eb-921c-19841d499051.png)

### Steps
* Unit tests - Run unit tests for all source code
* Static code analysis (PMD, Checkstyle, Linting) - Run static analysis for all source code
* Secrets scanner - Look for secrets embedded in source
* Code coverage - Pull code coverage numbers and make decision based on results

### Goals
* Fail fast if any of the steps fail
* Validate source code for artifact build

> NOTE: The conclusion of this stage will have all docker images created in the GCR related to the [**PROJECT_ID**](#environment-variables). Additionally, an attestation will be created

### Hands-On

1. Fork this repo
1. Create & satisfy **[Environment Variables](#environment-variables)** and **[Command Line Tools](#command-line-tools)**
1. Run `one-time-setup.sh`
    ```bash
    ./one-time-setup.sh
    ```

## 2. Artifact before deployment
This next stage is to verify the artifact before it has been deployed

```mermaid
flowchart TB
    D2(Container Structure Test)
    D3(Container Analysis)
    CR[[Container Registry]]

    subgraph before [Artifact Before Deploy]
        CR:::stage2 --> D2:::stage3
        CR --> D3:::stage3
    end

    img(Image Creation) --> before

    %% Apply a "Google" theme for fun
    classDef subg stroke:#000,stroke-width:4px,fill:#fff,color:#000,font-size:normal
    classDef stage0 stroke:#fff,fill:#80868B,color:#000
    classDef stage1 stroke:#fff,fill:#EA4335,color:#fff
    classDef stage2 stroke:#fff,fill:#34A853,color:#fff
    classDef stage3 stroke:#fff,fill:#4285F4,color:#fff
    classDef stage4 stroke:#fff,fill:#FBBC04,color:#fff
    classDef bg fill:#fff,stroke:#80868B,color:#202124

    class img stage2
    class before subg
    class before bg;
```
### Steps
* Container Structure Tests - Verify that the container built conforms to the organizational standards
* Container Analysis - Verify that the container does not contain Common Vulnerabilities or Exposures (CVEs) per the organization's standards

### Goals
* Fail fast if any of the steps fail
* Validate the artifact build to be ready for lower-level environments
* Artifact passes basic organization policy regulations

### Hands-On

1. Add steps to `cloudbuild.yaml`
1. TBD (figuring out how to make this a step-by-step)<!-- TODO: DO THIS STEP>
1. Run pipeline
    ```bash
    gcloud builds submit
    ```

## 3. Create Security Attestation
The final step in the `Continuous Integration` phase is to create an Attestation to attest to the fact that the container has successfully completed the previous steps.

```mermaid
flowchart TB

    subgraph attestation [Security Acceptance]
        SA(Create Security Attestation):::stage4 --> T[/Trigger Next Phase/]:::stage4
    end

    before(Artifact Before Deploy) --> attestation

    %% Apply a "Google" theme for fun
    classDef subg stroke:#000,stroke-width:4px,fill:#fff,color:#000,font-size:normal
    classDef stage0 stroke:#fff,fill:#80868B,color:#000
    classDef stage1 stroke:#fff,fill:#EA4335,color:#fff
    classDef stage2 stroke:#fff,fill:#34A853,color:#fff
    classDef stage3 stroke:#fff,fill:#4285F4,color:#fff
    classDef stage4 stroke:#fff,fill:#FBBC04,color:#fff
    classDef bg fill:#fff,stroke:#80868B,color:#202124

    class before stage3
    class attestation bg;
```
### Steps
* Create Attestation - The only step in this phase is to create an attestation for the artifact. This requires the artifact's image-digest as well as access to the Actor/Signer for automated security.

### Goals
* Create an attestation using the Security attestor

### Hands-On

1. Add steps to `cloudbuild.yaml`
1. Run pipeline
    ```bash
    gcloud builds submit
    ```

# Cleaning Up

The `cleanup.sh` script is provided to clean up only this repository, but does NOT manage any GCP project infrastructure or state. The script's primary purpose is to reset this repository allowing the Cloud Build runs to be reset and re-run.
