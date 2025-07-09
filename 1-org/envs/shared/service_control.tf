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

  shared_vpc_projects_numbers = [
    for v in values({
      for k, m in module.environment_network :
      k => m.shared_vpc_project_number
    }) : tostring(v)
  ]

  projects = distinct(concat([
    local.seed_project_number,
    module.org_audit_logs.project_number,
    module.org_billing_export.project_number,
    module.common_kms.project_number,
    module.org_secrets.project_number,
    module.interconnect.project_number,
    module.scc_notifications.project_number,
    ], local.shared_vpc_projects_numbers
  ))

  resource_keys_dry_run = [
    "prj-org-seed",
    "prj-org-audit",
    "prj-org-billing",
    "prj-org-kms",
    "prj-org-secrets",
    "prj-org-interconnect",
    "prj-org-scc",
    "prj-net-p-svpc",
    "prj-net-d-svpc",
    "prj-net-n-svpc",
  ]

  resource_keys = [
    "prj-org-seed",
    "prj-org-audit",
    "prj-org-billing",
    "prj-org-kms",
    "prj-org-secrets",
    "prj-org-interconnect",
    "prj-org-scc",
    "prj-net-p-svpc",
    "prj-net-d-svpc",
    "prj-net-n-svpc",
  ]

  projects_map = zipmap(
    local.resource_keys,
    [for p in local.projects : "${p}"]
  )

  projects_map_dry_run = zipmap(
    local.resource_keys_dry_run,
    [for p in local.projects : "${p}"]
  )


  egress_rules = [
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.scc_notifications.project_id}.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "${module.access_level.name}",
            "${module.access_level_dry_run.name}"
          ]
        }
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
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_audit_logs.project_id}.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "${module.access_level.name}",
            "${module.access_level_dry_run.name}"
          ]
        }
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
    {
      from = {
        identities = [
          "serviceAccount:${local.cloudbuild_project_number}@cloudbuild.gserviceaccount.com",
          "serviceAccount:service-${local.cloudbuild_project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "*",
          ]
        }
      }
      to = {
        resources = [
          "projects/${local.cloudbuild_project_number}",
          "projects/${local.seed_project_number}"
        ]
        operations = {
          "*" = {
            methods = ["*"]
          }
        }
      }
    }
    //Add egress rule SA bu1 infra pipeline
  ]

  egress_rules_dry_run = [
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.scc_notifications.project_id}.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "${module.access_level.name}",
            "${module.access_level_dry_run.name}"
          ]
        }
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
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_audit_logs.project_id}.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "${module.access_level.name}",
            "${module.access_level_dry_run.name}"
          ]
        }
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
    {
      from = {
        identities = [
          "serviceAccount:${local.cloudbuild_project_number}@cloudbuild.gserviceaccount.com",
          "serviceAccount:service-${local.cloudbuild_project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "*",
          ]
        }
      }
      to = {
        resources = [
          "projects/${local.cloudbuild_project_number}",
          "projects/${local.seed_project_number}"
        ]
        operations = {
          "*" = {
            methods = ["*"]
          }
        }
      }
    }
    //Add egress rule SA bu1 infra pipeline
  ]

  required_ingress_rules = [
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_billing_export.project_id}.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "${module.access_level.name}",
            "${module.access_level_dry_run.name}"
          ]
        }
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
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_audit_logs.project_id}.iam.gserviceaccount.com",
          "serviceAccount:service-${local.service_account_parent_id}@gcp-sa-logging.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "${module.access_level.name}",
            "${module.access_level_dry_run.name}"
          ]
        }
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
    },
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:service-${local.cloudbuild_project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
          "serviceAccount:${local.cloudbuild_project_number}@cloudbuild.gserviceaccount.com",
        ]
        sources = {
          access_levels = ["*"]
        }
      }
      to = {
        resources = [
          "*"
        ]
        operations = {
          "*" = {
            methods = ["*"]
          }
        }
      }
    }
  ]

  required_ingress_rules_dry_run = [
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_billing_export.project_id}.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "${module.access_level.name}",
            "${module.access_level_dry_run.name}"
          ]
        }
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
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:project-service-account@${module.org_audit_logs.project_id}.iam.gserviceaccount.com",
          "serviceAccount:service-${local.service_account_parent_id}@gcp-sa-logging.iam.gserviceaccount.com"
        ]
        sources = {
          access_levels = [
            "${module.access_level.name}",
            "${module.access_level_dry_run.name}"
          ]
        }
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
    },
    {
      from = {
        identities = [
          "serviceAccount:sa-terraform-org@${local.seed_project_id}.iam.gserviceaccount.com",
          "serviceAccount:service-${local.cloudbuild_project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
          "serviceAccount:${local.cloudbuild_project_number}@cloudbuild.gserviceaccount.com",
        ]
        sources = {
          access_levels = ["*"]
        }
      }
      to = {
        resources = [
          "*"
        ]
        operations = {
          "*" = {
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
    "serviceAccount:${local.environment_service_account}",
    "serviceAccount:service-${local.cloudbuild_project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    "serviceAccount:${local.cloudbuild_project_number}@cloudbuild.gserviceaccount.com",
    "serviceAccount:service-${local.service_account_parent_id}@gcp-sa-logging.iam.gserviceaccount.com",
    "serviceAccount:service-b-${local.billing_account}@gcp-sa-logging.iam.gserviceaccount.com"
  ], var.perimeter_additional_members))
  resources     = concat(values(local.projects_map), var.resources)
  resource_keys = local.resource_keys
  members_dry_run = distinct(concat([
    "serviceAccount:${local.networks_service_account}",
    "serviceAccount:${local.projects_service_account}",
    "serviceAccount:${local.organization_service_account}",
    "serviceAccount:${local.environment_service_account}",
    "serviceAccount:service-${local.cloudbuild_project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    "serviceAccount:${local.cloudbuild_project_number}@cloudbuild.gserviceaccount.com",
    "serviceAccount:service-${local.service_account_parent_id}@gcp-sa-logging.iam.gserviceaccount.com",
    "serviceAccount:service-b-${local.billing_account}@gcp-sa-logging.iam.gserviceaccount.com"
  ], var.perimeter_additional_members))
  resources_dry_run        = concat(values(local.projects_map), var.resources_dry_run)
  resource_keys_dry_run    = local.resource_keys_dry_run
  ingress_policies         = var.enable_required_ingress_rules ? distinct(concat(var.ingress_policies, local.required_ingress_rules)) : tolist([])
  ingress_policies_dry_run = var.enable_required_ingress_rules_dry_run ? distinct(concat(var.ingress_policies_dry_run, local.required_ingress_rules_dry_run)) : tolist([])
  egress_policies          = distinct(concat(var.egress_policies, local.egress_rules))
  egress_policies_dry_run  = distinct(concat(var.egress_policies_dry_run, local.egress_rules_dry_run))

  depends_on = [
    time_sleep.wait_projects
  ]
}
