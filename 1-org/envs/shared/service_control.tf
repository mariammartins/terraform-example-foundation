/**
 * Copyright 2023 Google LLC
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

/******************************************
 Shared VPC
*****************************************/

locals {
  supported_restricted_service = [
    "serviceusage.googleapis.com",
    "essentialcontacts.googleapis.com",
    "accessapproval.googleapis.com",
    "adsdatahub.googleapis.com",
    "aiplatform.googleapis.com",
    "alloydb.googleapis.com",
    "alpha-documentai.googleapis.com",
    "analyticshub.googleapis.com",
    "apigee.googleapis.com",
    "apigeeconnect.googleapis.com",
    "artifactregistry.googleapis.com",
    "assuredworkloads.googleapis.com",
    "automl.googleapis.com",
    "baremetalsolution.googleapis.com",
    "batch.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerydatapolicy.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigtable.googleapis.com",
    "binaryauthorization.googleapis.com",
    "cloud.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddebugger.googleapis.com",
    "clouddeploy.googleapis.com",
    "clouderrorreporting.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudprofiler.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudsearch.googleapis.com",
    "cloudtrace.googleapis.com",
    "composer.googleapis.com",
    "compute.googleapis.com",
    "connectgateway.googleapis.com",
    "contactcenterinsights.googleapis.com",
    "container.googleapis.com",
    "containeranalysis.googleapis.com",
    "containerfilesystem.googleapis.com",
    "containerregistry.googleapis.com",
    "containerthreatdetection.googleapis.com",
    "datacatalog.googleapis.com",
    "dataflow.googleapis.com",
    "datafusion.googleapis.com",
    "datamigration.googleapis.com",
    "dataplex.googleapis.com",
    "dataproc.googleapis.com",
    "datastream.googleapis.com",
    "dialogflow.googleapis.com",
    "dlp.googleapis.com",
    "dns.googleapis.com",
    "documentai.googleapis.com",
    "domains.googleapis.com",
    "eventarc.googleapis.com",
    "file.googleapis.com",
    "firebaseappcheck.googleapis.com",
    "firebaserules.googleapis.com",
    "firestore.googleapis.com",
    "gameservices.googleapis.com",
    "gkebackup.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "healthcare.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "iaptunnel.googleapis.com",
    "ids.googleapis.com",
    "integrations.googleapis.com",
    "kmsinventory.googleapis.com",
    "krmapihosting.googleapis.com",
    "language.googleapis.com",
    "lifesciences.googleapis.com",
    "logging.googleapis.com",
    "managedidentities.googleapis.com",
    "memcache.googleapis.com",
    "meshca.googleapis.com",
    "meshconfig.googleapis.com",
    "metastore.googleapis.com",
    "ml.googleapis.com",
    "monitoring.googleapis.com",
    "networkconnectivity.googleapis.com",
    "networkmanagement.googleapis.com",
    "networksecurity.googleapis.com",
    "networkservices.googleapis.com",
    "notebooks.googleapis.com",
    "opsconfigmonitoring.googleapis.com",
    "orgpolicy.googleapis.com",
    "osconfig.googleapis.com",
    "oslogin.googleapis.com",
    "privateca.googleapis.com",
    "pubsub.googleapis.com",
    "pubsublite.googleapis.com",
    "recaptchaenterprise.googleapis.com",
    "recommender.googleapis.com",
    "redis.googleapis.com",
    "retail.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "servicecontrol.googleapis.com",
    "servicedirectory.googleapis.com",
    "spanner.googleapis.com",
    "speakerid.googleapis.com",
    "speech.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "storagetransfer.googleapis.com",
    "sts.googleapis.com",
    "texttospeech.googleapis.com",
    "timeseriesinsights.googleapis.com",
    "tpu.googleapis.com",
    "trafficdirector.googleapis.com",
    "transcoder.googleapis.com",
    "translate.googleapis.com",
    "videointelligence.googleapis.com",
    "vision.googleapis.com",
    "visionai.googleapis.com",
    "vmmigration.googleapis.com",
    "vpcaccess.googleapis.com",
    "webrisk.googleapis.com",
    "workflows.googleapis.com",
    "workstations.googleapis.com",
  ]

  restricted_services         = length(var.custom_restricted_services) != 0 ? var.custom_restricted_services : local.supported_restricted_service
  restricted_services_dry_run = length(var.custom_restricted_services_dry_run) != 0 ? var.custom_restricted_services : local.supported_restricted_service

  # ingress_policies = [
  #   {
  #     title = "Ingress rule 1"
  #     from = [
  #       {
  #         identity_type = "ANY_IDENTITY"
  #         sources = [
  #           {
  #             resource = "projects/42184019201"
  #           },
  #           {
  #             resource = "projects/163357783814"
  #           }
  #         ]
  #       }
  #     ]

  #     to = {
  #       resources = ["*"]
  #       operations = [
  #         {
  #           service_name = "logging.googleapis.com"
  #           method_selectors = [
  #             {
  #               method = "*"
  #             }
  #           ]
  #         }
  #       ]
  #     }, title = "Ingress rule 2"
  #     from = [
  #       {
  #         identity_type = "ANY_IDENTITY"
  #         sources = [
  #           {
  #             resource = "projects/163357783814"
  #           }
  #         ]
  #       }
  #     ]
  #     to = {
  #       resources = ["*"]
  #       operations = [
  #         {
  #           service_name = "storage.googleapis.com"
  #           method_selectors = [
  #             {
  #               method = "*"
  #             }
  #           ]
  #         }
  #       ]
  #     }
  #   }
  # ]

 ingress_policies = [
    {
      from = {
        //identity_type = "ANY_IDENTITY"
       identity_type = ""
        identities = [
          "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com"//,
          //"serviceAccount:project-service-account@PROJECT_BILLING_EXPORT_ID.iam.gserviceaccount.com"
        ]
        sources = {
          resource = "projects/623969658122" //,
          //resource = "projects/623969658122"
        }
      }
      to = {
        resources = [
          "projects/42184019201"
        ]
        operations = {
          "bigquery.googleapis.com" = {
            methods = ["*"]
          }
          "pubsub.googleapis.com" = {
            methods = ["*"]
          }
          # "artifactregistry.googleapis.com" = {
          #   methods = ["*"]
          # }
        }
      }
    },
    {
      from = {
        identity_type = ""
        identities = [
          "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com" //,
          //"serviceAccount:project-service-account@PROJECT_LOGGING_ID.iam.gserviceaccount.com"
        ]
        sources = {
          resource = "projects/623969658122",
          resource = "projects/317298441760"
        }
      }
      to = {
        resources = [
          "projects/42184019201"//,
          //"projects/12312312312"
        ]
        operations = {
          "storage.googleapis.com" = {
            methods = ["*"]
          }
        }
      }
    }
  ]


  /////dry-run
  ingress_policies_dry_run = [
    {
      from = {
        //identity_type = "ANY_IDENTITY"
       identity_type = ""
        identities = [
          "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com"//,
          //"serviceAccount:project-service-account@PROJECT_BILLING_EXPORT_ID.iam.gserviceaccount.com"
        ]
        sources = {
          resource = "projects/623969658122",
          resource = "projects/317298441760"
        }
      }
      to = {
        resources = [
          "projects/42184019201"
        ]
        operations = {
          "cloudfunctions.googleapis.com" = {
            methods = ["*"]
          }
        }
      }
    },
    {
      from = {
        identity_type = ""
        identities = [
          "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com" //,
          //"serviceAccount:project-service-account@PROJECT_LOGGING_ID.iam.gserviceaccount.com"
        ]
        # sources = {
        #   resource = "projects/623969658122" //,
        #   //resource = "projects/623969658122"
        # }
      }
      to = {
        resources = [
          "projects/42184019201" //,
          //"projects/12312312312"
        ]
        operations = {
          "cloudfunctions.googleapis.com" = {
            methods = ["*"]
          }
          "storage.googleapis.com" = {
            methods = ["*"]
          }
          # "run.googleapis.com" = {
          #   methods = ["*"]
          # }
        }
      }
    }
  ]
}

module "service_control" {
  source = "../../modules/service_control"

  access_context_manager_policy_id = var.access_context_manager_policy_id
  restricted_services              = local.restricted_services
  restricted_services_dry_run      = local.restricted_services_dry_run
  members = distinct(concat([
    "serviceAccount:${local.networks_service_account}",
    "serviceAccount:${local.projects_service_account}",
    "serviceAccount:${local.organization_service_account}",
    "serviceAccount:${local.environment_service_account}"
  ], var.perimeter_additional_members))
  resources = distinct([
    local.seed_project_number, //42184019201
    "1005098596866",           // prj-c-billing-export-8f0e
    "163357783814",            // prj-c-logging-1s0a
    # "42184019201",//prj-b-seed-c507
    "651399064839", // prj-c-kms-m27z
    "658193253743", // prj-c-scc-btid
    "130486420663", // prj-c-secrets-3k5a
    "823601631320", // prj-d-svpc-mojc
    "404448127608", // prj-n-svpc-ydpo
    "438975717654", // prj-net-interconnect-qxc2
    "942489737540"  // prj-p-svpc-krnv
  ])
  members_dry_run = distinct(concat([
    "serviceAccount:${local.networks_service_account}",
    "serviceAccount:${local.projects_service_account}",
    "serviceAccount:${local.organization_service_account}",
    "serviceAccount:${local.environment_service_account}"
  ], var.perimeter_additional_members))
  resources_dry_run = distinct(concat([
    local.seed_project_number, //42184019201
    "1005098596866",           // prj-c-billing-export-8f0e
    "163357783814",            // prj-c-logging-1s0a
    # "42184019201",//prj-b-seed-c507
    "651399064839", // prj-c-kms-m27z
    "658193253743", // prj-c-scc-btid
    "130486420663", // prj-c-secrets-3k5a
    "823601631320", // prj-d-svpc-mojc
    "404448127608", // prj-n-svpc-ydpo
    "438975717654", // prj-net-interconnect-qxc2
    "942489737540"  // prj-p-svpc-krnv
  ]))
  ingress_policies         = local.ingress_policies
  ingress_policies_dry_run = local.ingress_policies_dry_run
  #egress_policies          = distinct(local.egress_policies)
  #egress_policies_dry_run  = distinct(local.egress_policies)

  depends_on = [
    time_sleep.wait_projects
  ]
}

