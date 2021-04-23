#!/usr/bin/env bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
parent_dir=$( dirname "$(pwd)" )

# Get example-foundation
if [[ ! -d "$parent_dir/3-networks" ]]; then
    git clone --depth 1 --filter=blob:none https://github.com/terraform-google-modules/terraform-example-foundation example-foundation
    mv example-foundation/3-networks/ "$parent_dir"
    mv example-foundation/build/cloudbuild-tf-* "$parent_dir"/../build
    mv example-foundation/build/tf-wrapper.sh "$parent_dir"/../build
    rm -rf example-foundation
fi
if [[ ! -f "$parent_dir/3-networks/envs/development/boa_*" ]]; then
    cd "$parent_dir"/3-networks-extension/
    # transfer boa tf files
    for dir in envs/*/ ; do
        cp "$dir"boa_* "$parent_dir"/3-networks/"$dir"
    done
    cp -r modules/fw-rules "$parent_dir"/3-networks/modules
    cd "$parent_dir"/3-networks/
    # Change region in commom.tfvars
    sed -i 's/central1/east1/g' common.auto.example.tfvars
    # Remove base_shared_vpc from upstream main.tf
    for dir in envs/*/ ; do
        if [[ ! "${dir}" == "envs/shared/" ]]; then
            sed -e '/Base shared VPC/,$d' "$dir"main.tf | tac | sed "1,2d" | tac >> "$dir"tmp_main.tf
            rm "$dir"main.tf
            mv "$dir"tmp_main.tf "$dir"main.tf
        fi
    done
fi
