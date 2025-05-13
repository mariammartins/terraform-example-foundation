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

  ingress_policies = [
    # prj-c-billing-export 
    # Ingress policy into $commonPerimeter, specific identity and service of bq export
    {
      from = {
        identity_type = ""
        identities = [
          "serviceAccount:sa-terraform-org@PROJECT_SEED_ID.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@PROJECT_BILLING_EXPORT_ID.iam.gserviceaccount.com"
        ]
        sources = {
          access_level = module.service_control.access_level_name
        }
      }
      to = {
        resources = [
          "projects/PROJECT_BILLING_EXPORT_ID",
        ]
        operations = {
          "bigquery.googleapis.com" = {
            methods = ["*"]
          }
        }
      }
    },
    # prj-c-logging
    # Ingress policy from $commonPerimeter, specify identity and service of log sinks
    {
      from = {
        identity_type = ""
        identities = [
          "serviceAccount:sa-terraform-org@PROJECT_SEED_ID.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@PROJECT_LOGGING_ID.iam.gserviceaccount.com",
        ]
        sources = {
          access_level = module.service_control.access_level_name
        }
      }
      to = {
        resources = [
          "projects/PROJECT_LOGGING_ID",
        ]
        operations = {
          "logging.googleapis.com" = {
            methods = ["*"]
          }
        }
      }
    }
  ]

  egress_policies = [
    {
      # prj-c-scc
      # Egress policy from $ $commonPerimeter, specific identity and services related to CAI feeds
      from = {
        identity_type = ""
        identities = [
          "serviceAccount:sa-terraform-org@PROJECT_SEED_ID.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@PROJECT_SCC_ID.iam.gserviceaccount.com"
        ]

      }
      to = {
        resources = [
          "projects/PROJECT_SCC_ID",
        ]
        operations = {
          "cloudresourcemanager.googleapis.com" = {
            methods = ["*"]
          }
          "cloudfunctions.googleapis.com" = {
            methods = ["*"]
          }
          "cloudbuild.googleapis.com" = {
            methods = ["*"]
          }
          "cloudasset.googleapis.com" = {
            methods = ["*"]
          }
          "pubsub.googleapis.com" = {
            methods = ["*"]
          }
          "artifactregistry.googleapis.com" = {
            methods = ["*"]
          }
          "storage.googleapis.com" = {
            methods = ["*"]
          }
          "run.googleapis.com" = {
            methods = ["*"]
          }
          "eventarc.googleapis.com" = {
            methods = ["*"]
          }
        }
      }
    },
    {
      # prj-c-logging
      # Egress policy from $commonPerimeter, specify identity and service of log sinks
      from = {
        identity_type = ""
        identities = [
          "serviceAccount:sa-terraform-org@PROJECT_SEED_ID.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@PROJECT_LOGGING_ID.iam.gserviceaccount.com"
        ]

      }
      to = {
        resources = [
          "projects/PROJECT_LOGGING_NUMBER",
        ]
        operations = {
          "cloudresourcemanager.googleapis.com" = {
            methods = ["*"]
          }
          "cloudfunctions.googleapis.com" = {
            methods = ["*"]
          }
          "cloudbuild.googleapis.com" = {
            methods = ["*"]
          }
          "cloudasset.googleapis.com" = {
            methods = ["*"]
          }
          "pubsub.googleapis.com" = {
            methods = ["*"]
          }
          "artifactregistry.googleapis.com" = {
            methods = ["*"]
          }
          "storage.googleapis.com" = {
            methods = ["*"]
          }
          "run.googleapis.com" = {
            methods = ["*"]
          }
          "eventarc.googleapis.com" = {
            methods = ["*"]
          }
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
    local.seed_project_number,
    "913576875098",// prj-c-billing-export-h9fy
    "130148430584",// prj-c-logging-wxgu
    "1065327696106",//prj-b-seed-c507
    "348715422838",// prj-c-kms-7dc7
    "971741096857",// prj-c-scc-b7mb
    "903983488123",// prj-c-secrets-779t
    "408558630155",// prj-d-svpc-yeqf
    "1070091425805",// prj-n-svpc-zzhb
    "7249033203",// prj-net-interconnect-0h2s
    "234315486213"// prj-p-svpc-cbk1
  ])
  members_dry_run = distinct(concat([
    "serviceAccount:${local.networks_service_account}",
    "serviceAccount:${local.projects_service_account}",
    "serviceAccount:${local.organization_service_account}",
    "serviceAccount:${local.environment_service_account}"
  ], var.perimeter_additional_members))
  resources_dry_run = distinct(concat([
    local.seed_project_number,
    "913576875098",// prj-c-billing-export-h9fy
    "130148430584",// prj-c-logging-wxgu
    "1065327696106",//prj-b-seed-c507
    "348715422838",// prj-c-kms-7dc7
    "971741096857",// prj-c-scc-b7mb
    "903983488123",// prj-c-secrets-779t
    "408558630155",// prj-d-svpc-yeqf
    "1070091425805",// prj-n-svpc-zzhb
    "7249033203",// prj-net-interconnect-0h2s
    "234315486213"// prj-p-svpc-cbk1
  ]))
  ingress_policies         = local.ingress_policies
  ingress_policies_dry_run = local.ingress_policies
  #ingress_policies_dry_run = distinct(concat(local.ingress_policies))
  egress_policies          = distinct(local.egress_policies)
  egress_policies_dry_run  = distinct(local.egress_policies)
  #egress_policies_dry_run  = distinct(concat(local.egress_policies))
  # ingress_policies         = var.ingress_policies
  # ingress_policies_dry_run = var.ingress_policies_dry_run
  # egress_policies          = distinct(var.egress_policies)
  # egress_policies_dry_run  = distinct(var.egress_policies_dry_run)

  depends_on = [
    resource.time_sleep.wait_projects
   ]
}
