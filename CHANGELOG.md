# Changelog

## 0.1.0 (2024-02-23)


### Features

* 3-network-script ([#19](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/19)) ([924cd2a](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/924cd2a2043202739f92fb36c06394bd3925f6ba))
* 3-networks updates for BoA ([be49443](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/be4944375537431361922b59688db5a5be9048f9))
* add 5-infra envs ([#10](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/10)) ([3856f69](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/3856f69937fccfe1cfef80f2b216e340fa167756))
* add base-env module ([#6](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/6)) ([fcf8d1f](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/fcf8d1f85d07739f3a2d4b8efe9a33e58194146c))
* Add bastion allow list configuration ([#72](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/72)) ([5725b61](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/5725b6153bcdd53688b13cee9792138b97a608fc))
* add bastion module ([#1](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/1)) ([c5ce7f3](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/c5ce7f3f104aa76c2fef9012a34f9ee5eb84aaf0))
* add cicd pipeline ([#16](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/16)) ([dd6c10b](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/dd6c10b975e6cf4dd8690dee2982c7e3f3a1789b))
* add cloud-sql module ([#7](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/7)) ([5f3a10e](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/5f3a10e21379f0647ffdda6d7b729f108a0e6840))
* add GAR to cicd pipeline ([#22](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/22)) ([324374f](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/324374ff1d75224b878d84230c8b93ed31446d7e))
* Added boa projects and app,infra pipeline projects ([#8](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/8)) ([7cd5e3c](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/7cd5e3c12469f9269fec1302d5892c60dfb1cf13))


### Bug Fixes

* add explicit remote in git command ([d549737](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/d549737be96de4660087e8210aab1f2b4f88e6f4))
* allow-google-apis tag & sql private ip remove ([#12](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/12)) ([bd19f08](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/bd19f08b24a0dc2f89340ddea911e960cea82cfc))
* bump boa base manifests to latest ([#98](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/98)) ([e20ce9a](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/e20ce9a544afba7216cbc08347cf8d889b6e6ca0))
* configure access to the SQL servers ([#70](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/70)) ([ddd0688](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/ddd068858299e524cd77b1a5ca69caae27442fb6))
* enable lint tests ([#3](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/3)) ([fdd319e](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/fdd319e20453392d7e3db352ca15f82dfbf1ed90))
* env 4-projects production non-production ([#81](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/81)) ([a45045d](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/a45045dd699aece543d36e69e714411e73dbef02))
* Fix database user creation ([#58](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/58)) ([de00f4f](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/de00f4fe2540912949a6fc32691c14964211c2d3))
* Fix terraform validator issues ([#55](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/55)) ([5323650](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/532365030b603479d8d1b569de09b411834cf1d1))
* Fix/update acm asm ([#50](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/50)) ([5b02673](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/5b02673ce839e2ec0f35b2039f57d365e3fbcab9))
* fixes for issues 41-42-43-47 ([#48](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/48)) ([9165916](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/91659168b381be592510e1b366205c39d6b649ce))
* grant browser roles to cloud build service account ([#74](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/74)) ([f5ddbb3](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/f5ddbb3bc5669edc00b9bce48643f33c5ccbf554))
* infra-pipelines module now requires service account impersonation ([#40](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/40)) ([a6d5426](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/a6d5426776fb366ad689f9f53521894831625f68))
* Instructions for installing ASM and ACM ([#18](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/18)) ([a7d0b5b](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/a7d0b5bcd53d588ebcba2bb9262a3a1c4b606eae))
* network_prepare script ([#26](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/26)) ([036a740](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/036a740f015f3149687751681e18b03a07b0f705))
* path to mesh-external-svc.yaml file to point to the transactions folder ([#79](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/79)) ([ce45993](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/ce4599359153f980ec7f9f7b8e52f949b4ef5130))
* SA creation and IAM in 4-projects ([#17](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/17)) ([b864c2f](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/b864c2fa30fe2b999ed778f768c35b4c4d9be3d3))
* typo anthos readme ([3ae320e](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/3ae320e356ad9a76e32331a21a4eb91a333f0d1d))
* UAT feedback and readmes ([#27](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/27)) ([227c5e8](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/227c5e8ada9077654629dc8b58852d37f25abb2a))
* UAT2 feedback changes ([#30](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/30)) ([6b79823](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/6b79823dd64998b37cf58c218870d00a24a9b662))
* UAT3 Testing Feedback ([#31](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/31)) ([d92e894](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/d92e89485d2b6ea1caf633b66b41d8a10380e64d))
* UAT4 Testing Feedback ([#36](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/36)) ([4462908](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/4462908566c6d417c5076271cd06ded5204aff5b))
* unify asm version ([#66](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/66)) ([03ad039](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/03ad03917bbd7e89139051fc16b5b25114ff7949))
* update cluster subnet_ip cidr range ([#78](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/78)) ([5186994](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/51869946468d4a2907870b1a1d8a0c3611d0f193))
* Update GKE configuration and CPU resource limits ([#68](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/68)) ([feb3e91](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/feb3e9179673a67ec180969ba03f2bdbe9e11642))
* Updated Firewall Rules for bastion egress ([#29](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/29)) ([cac1d01](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/cac1d014e7dc20403f71b6e295a0c457424b381a))
* variables and filenames ([#28](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/issues/28)) ([706afaf](https://github.com/GoogleCloudPlatform/terraform-example-foundation-app/commit/706afaf5b36065cbd3190617508197e50ccce294))
