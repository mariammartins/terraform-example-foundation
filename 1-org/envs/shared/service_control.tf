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


  ingress_rules = {
    rule_ingress_billing_export = {
      service_name = "logging.googleapis.com"
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-billing-export-8f0e.iam.gserviceaccount.com"
      ]
      sources = {
        resources = [
          "projects/42184019201",
          "projects/1005098596866"
        ]
      }
      resources = [
        "projects/438975717654"
      ]
    }
    rule_ingress_logging = {
      service_name = "bigquery.googleapis.com"
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-p-svpc-krnv.iam.gserviceaccount.com"
      ]
      sources = {
        resources = [
          "projects/42184019201",
          "projects/130486420663",
          "projects/1005098596866",
          "projects/942489737540"
        ]
      }
      resources = [
        "projects/942489737540"
      ]
    }
  }

  egress_rules = {
    rule_egress_c_scc = {
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-scc-btid.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/658193253743"
      ]
      operations = {
        cloudresourcemanager = {
          service_name = "cloudresourcemanager.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudfunctions = {
          service_name = "cloudfunctions.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudbuild = {
          service_name = "cloudbuild.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudasset = {
          service_name = "cloudasset.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        pubsub = {
          service_name = "pubsub.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        artifactregistry = {
          service_name = "artifactregistry.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        storage = {
          service_name = "storage.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        run = {
          service_name = "run.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        eventarc = {
          service_name = "eventarc.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
      }
    }

    rule_egress_c_logging = {
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-logging-1s0a.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/163357783814"
      ]
      operations = {
        cloudresourcemanager = {
          service_name = "cloudresourcemanager.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudfunctions = {
          service_name = "cloudfunctions.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudbuild = {
          service_name = "cloudbuild.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudasset = {
          service_name = "cloudasset.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        pubsub = {
          service_name = "pubsub.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        artifactregistry = {
          service_name = "artifactregistry.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        storage = {
          service_name = "storage.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        run = {
          service_name = "run.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        eventarc = {
          service_name = "eventarc.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
      }
    }
    rule_egress_cloudbuild = {
      identities = [
        "serviceAccount:service-623969658122@gcp-sa-cloudbuild.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/42184019201",
        "projects/623969658122"
      ]
      resources = [
        "projects/42184019201"
      ]
      operations = {
        all_services = {
          service_name = "*"
          method_selectors = [
          ]
        }
      }
    }
  }

  ingress_rules_dry_run = {
    rule_ingress_billing_export = {
      service_name = "logging.googleapis.com"
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-billing-export-8f0e.iam.gserviceaccount.com"
      ]
      sources = {
        resources = [
          "projects/42184019201",
          "projects/1005098596866"
        ]
      }
      resources = [
        "projects/438975717654"
      ]
    }
    rule_ingress_logging = {
      service_name = "bigquery.googleapis.com"
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-p-svpc-krnv.iam.gserviceaccount.com"
      ]
      sources = {
        resources = [
          "projects/42184019201",
          "projects/130486420663",
          "projects/1005098596866",
          "projects/942489737540"
        ]
      }
      resources = [
        "projects/942489737540"
      ]
    }
  }

  egress_rules_dry_run = {
    rule_egress_c_scc = {
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-scc-btid.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/658193253743"
      ]
      operations = {
        cloudresourcemanager = {
          service_name = "cloudresourcemanager.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudfunctions = {
          service_name = "cloudfunctions.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudbuild = {
          service_name = "cloudbuild.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudasset = {
          service_name = "cloudasset.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        pubsub = {
          service_name = "pubsub.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        artifactregistry = {
          service_name = "artifactregistry.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        storage = {
          service_name = "storage.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        run = {
          service_name = "run.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        eventarc = {
          service_name = "eventarc.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
      }
    }

    rule_egress_c_logging = {
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-logging-1s0a.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/163357783814"
      ]
      operations = {
        cloudresourcemanager = {
          service_name = "cloudresourcemanager.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudfunctions = {
          service_name = "cloudfunctions.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudbuild = {
          service_name = "cloudbuild.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        cloudasset = {
          service_name = "cloudasset.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        pubsub = {
          service_name = "pubsub.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        artifactregistry = {
          service_name = "artifactregistry.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        storage = {
          service_name = "storage.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        run = {
          service_name = "run.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
        eventarc = {
          service_name = "eventarc.googleapis.com"
          method_selectors = [
            {
              method = "*"
            }
          ]
        }
      }
    }
    rule_egress_cloudbuild = {
      identities = [
        "serviceAccount:service-623969658122@gcp-sa-cloudbuild.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/42184019201",
        "projects/623969658122"
      ]
      resources = [
        "projects/42184019201"
      ]
      operations = {
        all_services = {
          service_name = "*"
          method_selectors = [
          ]
        }
      }
    }
  }

}

resource "google_access_context_manager_service_perimeter_ingress_policy" "ingress_policies_CB" {
  perimeter = "accessPolicies/${local.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"
  ingress_from {
    identity_type = ""
    identities = [
      "serviceAccount:service-623969658122@gcp-sa-cloudbuild.iam.gserviceaccount.com",
      "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com"
    ]
    sources {
      resource = "projects/623969658122"
    }
  }
  ingress_to {
    resources = [
      "projects/42184019201"
    ]

    operations {
      service_name = "bigquery.googleapis.com"
      method_selectors {
        method = "*"
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [module.service_control]
}

resource "google_access_context_manager_service_perimeter_dry_run_ingress_policy" "ingress_policies_dry_run_CB" {
  perimeter = "accessPolicies/${local.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"
  ingress_from {
    identity_type = ""
    identities = [
      "serviceAccount:service-623969658122@gcp-sa-cloudbuild.iam.gserviceaccount.com",
      "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com"
    ]
    sources {
      resource = "projects/623969658122"
    }
  }
  ingress_to {
    resources = [
      "projects/42184019201"
    ]

    operations {
      service_name = "bigquery.googleapis.com"
      method_selectors {
        method = "*"
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [module.service_control]
}

resource "google_access_context_manager_service_perimeter_ingress_policy" "ingress_policies" {
  for_each = local.ingress_rules

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

  depends_on = [module.service_control]
}

resource "google_access_context_manager_service_perimeter_dry_run_ingress_policy" "ingress_policies_dry_run" {
  for_each = local.ingress_rules_dry_run

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

  depends_on = [module.service_control]
}

resource "google_access_context_manager_service_perimeter_egress_policy" "egress_policies" {
  for_each = local.egress_rules

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

  depends_on = [module.service_control]
}

resource "google_access_context_manager_service_perimeter_dry_run_egress_policy" "egress_policies_dry_run" {
  for_each = local.egress_rules_dry_run

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

  depends_on = [module.service_control]
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
  var.resources
  ])
  members_dry_run = distinct(concat([
    "serviceAccount:${local.networks_service_account}",
    "serviceAccount:${local.projects_service_account}",
    "serviceAccount:${local.organization_service_account}",
    "serviceAccount:${local.environment_service_account}"
  ], var.perimeter_additional_members))
  resources_dry_run = distinct(concat([
  var.resources_dry_run
  ]))

  depends_on = [
    time_sleep.wait_projects
  ]
}

