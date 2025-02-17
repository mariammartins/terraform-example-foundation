/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*********************
 Restricted Outputs
*********************/

output "shared_host_project_id" {
  value       = local.shared_vpc_project_id
  description = "The host project ID"
}

output "restricted_shared_vpc_network_name" {
  value       = module.shared_vpc.restricted_network_name
  description = "The name of the VPC being created"
}

output "restricted_network_self_link" {
  value       = module.shared_vpc.restricted_network_self_link
  description = "The URI of the VPC being created"
}

output "restricted_subnets_names" {
  value       = module.shared_vpc.restricted_subnets_names
  description = "The names of the subnets being created"
}

output "restricted_subnets_ips" {
  value       = module.shared_vpc.restricted_subnets_ips
  description = "The IPs and CIDRs of the subnets being created"
}

output "restricted_subnets_self_links" {
  value       = module.shared_vpc.restricted_subnets_self_links
  description = "The self-links of subnets being created"
}

output "restricted_subnets_secondary_ranges" {
  value       = module.shared_vpc.restricted_subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}

output "restricted_access_level_name" {
  value       = module.shared_vpc.restricted_access_level_name
  description = "Access context manager access level name for the enforced perimeter"
}

output "restricted_access_level_name_dry_run" {
  value       = module.shared_vpc.restricted_access_level_name_dry_run
  description = "Access context manager access level name for the dry-run perimeter"
}

output "enforce_vpcsc" {
  value       = module.shared_vpc.enforce_vpcsc
  description = "Enable the enforced mode for VPC Service Controls. It is not recommended to enable VPC-SC on the first run deploying your foundation. Review [best practices for enabling VPC Service Controls](https://cloud.google.com/vpc-service-controls/docs/enable), then only enforce the perimeter after you have analyzed the access patterns in your dry-run perimeter and created the necessary exceptions for your use cases."
}

output "service_perimeter_name" {
  value       = module.shared_vpc.restricted_service_perimeter_name
  description = "Access context manager service perimeter name for the enforced perimeter"
}
