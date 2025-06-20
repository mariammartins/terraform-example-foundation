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
  ingress_rules               = var.enable_mandatory_ingress_rules ? local.mandatory_ingress_rules : []

  shared_vpc_projects_numbers = [
    for v in values({
      for k, m in module.environment_network :
      k => m.shared_vpc_project_number
    }) : tostring(v)
  ]

  egress_rules = [
    //prj-c-scc
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.scc_notifications.project_id}.iam.gserviceaccount.com"
        ]
      }
      to = {
        resources = [
          "projects/${module.scc_notifications.project_number}"
        ]
        operations = {
          for service in [
            "cloudresourcemanager.googleapis.com",
            "cloudfunctions.googleapis.com",
            "eventarc.googleapis.com",
            "run.googleapis.com",
            "storage.googleapis.com",
            "artifactregistry.googleapis.com",
            "pubsub.googleapis.com",
            "cloudasset.googleapis.com",
            "cloudbuild.googleapis.com"
          ] : service =>
          {
            methods = ["*"]
          }
        }
      }
    },
    //prj-c-logging
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_audit_logs.project_id}.iam.gserviceaccount.com"
        ]
      }
      to = {
        resources = [
          "projects/${module.org_audit_logs.project_number}"
        ]
        operations = {
          "logging.googleapis.com" = {
            methods = ["*"]
          }
        }
      }
    },
    //cloudbuild-egress-rule
    {
      from = {
        identities = [
          "serviceAccount:${local.cloudbuild_project_number}@cloudbuild.gserviceaccount.com"
        ]
      }
      to = {
        resources = [
          "projects/${local.cloudbuild_project_number}"
        ]
        operations = {
          "cloudbuild.googleapis.com" = {
            methods = ["*"]
          }
        }
      }
    }
  ]

  #   rule_egress_cloudbuild = {
  #     identities = [
  #       "serviceAccount:service-${local.cloudbuild_project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
  #       "serviceAccount:${local.cloudbuild_project_number}@cloudbuild.gserviceaccount.com" //,
  #       //the SA bellow can only be added after step 5-app-infra
  #       //"serviceAccount:BU1_INFRA_PIPELINE_CICD_PROJECT_NUMBER@cloudbuild.gserviceaccount.com",
  #       //"serviceAccount:sa-tf-cb-bu1-example-app@BU1_INFRA_PIPELINE_CICD_PROJECT_ID.iam.gserviceaccount.com"
  #     ]
  #     resources = [
  #       "projects/${local.seed_project_number}",
  #       "projects/${local.cloudbuild_project_number}"
  #     ]
  #     operations = {
  #       all_services = {
  #         service_name = "*"
  #         method_selectors = [
  #         ]
  #       }
  #     }
  #   }
  mandatory_ingress_rules = [
    //prj-c-billing-export
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_billing_export.project_id}.iam.gserviceaccount.com"
        ]
      }
      to = {
        resources = [
          "projects/${module.org_billing_export.project_number}"
        ]
        operations = {
          "logging.googleapis.com" = {
            methods = ["*"]
          }
        }
      }
    },
    //logging projects
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_audit_logs.project_id}.iam.gserviceaccount.com",
          "serviceAccount:service-folder-930514596188@gcp-sa-logging.iam.gserviceaccount.com" //930514596188 parent_id deploy folder ID
        ]
      }
      to = {
        resources = [
          "projects/${module.org_audit_logs.project_number}"
        ]
        operations = {
          for service in [
            "logging.googleapis.com",
            "pubsub.googleapis.com",
          ] : service =>
          {
            methods = ["*"]
          }
        }
      }
    }
  ]
}

resource "google_access_context_manager_service_perimeter_dry_run_ingress_policy" "ingress_policies_dry_run" {
  for_each = { for idx, policy in var.ingress_policies_dry_run : idx => policy }

  perimeter = "accessPolicies/${local.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"

  ingress_from {
    identity_type = ""
    identities    = each.value.identities

    dynamic "sources" {
      for_each = each.value.sources.resources
      content {
        resource = sources.value
      }
    }
  }

  ingress_to {
    resources = each.value.resources
    operations {
      service_name = each.value.service_name
      method_selectors {
        method = "*"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    module.service_control
  ]
}

resource "google_access_context_manager_service_perimeter_ingress_policy" "ingress_policies" {
  for_each = { for idx, policy in var.ingress_policies : idx => policy }

  perimeter = "accessPolicies/${local.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"

  ingress_from {
    identity_type = ""
    identities    = each.value.identities

    dynamic "sources" {
      for_each = each.value.sources.resources
      content {
        resource = sources.value
      }
    }
  }

  ingress_to {
    resources = each.value.resources
    operations {
      service_name = each.value.service_name
      method_selectors {
        method = "*"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    module.service_control
  ]
}

resource "google_access_context_manager_service_perimeter_egress_policy" "egress_policies" {
  for_each = { for idx, policy in var.egress_policies : idx => policy }

  perimeter = "accessPolicies/${local.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"

  egress_from {
    identity_type = ""
    identities    = each.value.identities
  }

  egress_to {
    resources = each.value.resources
    dynamic "operations" {
      for_each = [for op in each.value.operations : op]
      content {
        service_name = operations.value.service_name
        dynamic "method_selectors" {
          for_each = operations.value.method_selectors
          content {
            method = method_selectors.value.method
          }
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
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
    "serviceAccount:${local.environment_service_account}",
    "serviceAccount:service-812628934602@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    "serviceAccount:812628934602@cloudbuild.gserviceaccount.com",
    "serviceAccount:service-folder-77454778564@gcp-sa-logging.iam.gserviceaccount.com",
    "serviceAccount:service-b-010ECE-40301B-50DDD5@gcp-sa-logging.iam.gserviceaccount.com"
  ], var.perimeter_additional_members))
  resources = distinct(concat([
    local.seed_project_number,
    module.org_audit_logs.project_number,
    module.org_billing_export.project_number,
    module.common_kms.project_number,
    module.org_secrets.project_number,
    module.interconnect.project_number,
    module.scc_notifications.project_number,
    ], local.shared_vpc_projects_numbers, var.resources_dry_run
  ))
  members_dry_run = distinct(concat([
    "serviceAccount:${local.networks_service_account}",
    "serviceAccount:${local.projects_service_account}",
    "serviceAccount:${local.organization_service_account}",
    "serviceAccount:${local.environment_service_account}",
    # "serviceAccount:service-cloudbuild_project_number@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    # "serviceAccount:cloudbuild_project_number@cloudbuild.gserviceaccount.com",
    # "serviceAccount:service-folder-folder_number@gcp-sa-logging.iam.gserviceaccount.com",
    # "serviceAccount:service-b-billing_number@gcp-sa-logging.iam.gserviceaccount.com"
  ], var.perimeter_additional_members))
  resources_dry_run = distinct(concat([
    local.seed_project_number,
    module.org_audit_logs.project_number,
    module.org_billing_export.project_number,
    module.common_kms.project_number,
    module.org_secrets.project_number,
    module.interconnect.project_number,
    module.scc_notifications.project_number,
    ], local.shared_vpc_projects_numbers, var.resources_dry_run
  ))
  ingress_policies         = distinct(concat(var.ingress_policies, local.ingress_rules))
  ingress_policies_dry_run = distinct(concat(var.ingress_policies, local.ingress_rules))
  egress_policies          = distinct(concat(var.egress_policies, local.egress_rules))
  egress_policies_dry_run  = distinct(concat(var.egress_policies_dry_run, local.egress_rules))
  depends_on = [
    time_sleep.wait_projects
  ]
}

