<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_context\_manager\_policy\_id | The id of the default Access Context Manager policy created in step `1-org`. Can be obtained by running `gcloud access-context-manager policies list --organization YOUR_ORGANIZATION_ID --format="value(name)"`. | `number` | n/a | yes |
| default\_region1 | First subnet region. The shared vpc modules only configures two regions. | `string` | n/a | yes |
| default\_region2 | Second subnet region. The shared vpc modules only configures two regions. | `string` | n/a | yes |
| domain | The DNS name of peering managed zone, for instance 'example.com.'. Must end with a period. | `string` | n/a | yes |
| enable\_dedicated\_interconnect | Enable Dedicated Interconnect in the environment. | `bool` | `false` | no |
| enable\_partner\_interconnect | Enable Partner Interconnect in the environment. | `bool` | `false` | no |
| env | The environment to prepare (ex. development) | `string` | n/a | yes |
| environment\_code | A short form of the folder level resources (environment) within the Google Cloud organization (ex. d). | `string` | n/a | yes |
| remote\_state\_bucket | Backend bucket to load Terraform Remote State Data from previous steps. | `string` | n/a | yes |
| restricted\_private\_service\_cidr | CIDR range for private service networking. Used for Cloud SQL and other managed services in the Restricted Shared Vpc. | `string` | n/a | yes |
| restricted\_private\_service\_connect\_ip | The base subnet internal IP to be used as the private service connect endpoint in the Restricted Shared VPC | `string` | n/a | yes |
| restricted\_subnet\_primary\_ranges | The base subnet primary IPTs ranges to the Restricted Shared Vpc. | `map(string)` | n/a | yes |
| restricted\_subnet\_proxy\_ranges | The base proxy-only subnet primary IPTs ranges to the Restricted Shared Vpc. | `map(string)` | n/a | yes |
| restricted\_subnet\_secondary\_ranges | The base subnet secondary IPTs ranges to the Restricted Shared Vpc | `map(list(map(string)))` | n/a | yes |
| restricted\_vpc\_flow\_logs | aggregation\_interval: Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Possible values are: INTERVAL\_5\_SEC, INTERVAL\_30\_SEC, INTERVAL\_1\_MIN, INTERVAL\_5\_MIN, INTERVAL\_10\_MIN, INTERVAL\_15\_MIN.<br>  flow\_sampling: Set the sampling rate of VPC flow logs within the subnetwork where 1.0 means all collected logs are reported and 0.0 means no logs are reported. The value of the field must be in [0, 1].<br>  metadata: Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are: EXCLUDE\_ALL\_METADATA, INCLUDE\_ALL\_METADATA, CUSTOM\_METADATA.<br>  metadata\_fields: ist of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is enabled and "metadata" is set to CUSTOM\_METADATA.<br>  filter\_expr: Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field. | <pre>object({<br>    aggregation_interval = optional(string, "INTERVAL_5_SEC")<br>    flow_sampling        = optional(string, "0.5")<br>    metadata             = optional(string, "INCLUDE_ALL_METADATA")<br>    metadata_fields      = optional(list(string), [])<br>    filter_expr          = optional(string, "true")<br>  })</pre> | `{}` | no |
| tfc\_org\_name | Name of the TFC organization | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| restricted\_host\_project\_id | The restricted host project ID |
| restricted\_network\_name | The name of the VPC being created |
| restricted\_network\_self\_link | The URI of the VPC being created |
| restricted\_subnets\_ips | The IPs and CIDRs of the subnets being created |
| restricted\_subnets\_names | The names of the subnets being created |
| restricted\_subnets\_secondary\_ranges | The secondary ranges associated with these subnets |
| restricted\_subnets\_self\_links | The self-links of subnets being created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
