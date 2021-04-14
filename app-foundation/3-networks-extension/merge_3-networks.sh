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
parent_dir=$( dirname "$PWD" )
if [ ! -d "/path/to/dir" ]; then
    curl -L --fail https://github.com/terraform-google-modules/terraform-example-foundation/archive/refs/heads/master.tar.gz | tar xz --strip=1 "terraform-example-foundation-master/3-networks"
    mv 3-networks/ "$parent_dir"
fi

cd envs/
for dir in */ ; do
    mv "$dir"/boa_* "$parent_dir"/3-networks/env/"$dir"
done

cd ../../3-networks/

# Remove base_shared_vpc from upstream main.tf
# sed
