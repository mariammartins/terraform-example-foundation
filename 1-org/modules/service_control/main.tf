/**
 * Copyright 2021 Google LLC
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

locals {
  prefix                    = "svpc"
  access_level_name         = "alp_${local.prefix}_members_${random_id.random_access_level_suffix.hex}"
  access_level_name_dry_run = "alp_${local.prefix}_members_dry_run_${random_id.random_access_level_suffix.hex}"
  perimeter_name            = "sp_${local.prefix}_default_common_perimeter_${random_id.random_access_level_suffix.hex}"

ingress_rules = {
    rule_ingress_billing_export = {
      service_name = "logging.googleapis.com"
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-PROJECT_ID.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-billing-export-PROJECT_ID.iam.gserviceaccount.com"
      ]
      sources = {
        resources = [
          "projects/prj-b-seed_PROJECT_NUMBER",
          "projects/prj-c-billing-export_PROJECT_NUMBER"
        ]
      }
      resources = [
        "projects/prj-net-interconnect_PROJECT_NUMBER"
      ]
    }
    rule_ingress_logging = {
      service_name = "bigquery.googleapis.com"
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-PROJECT_ID.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-p-svpc-PROJECT_ID.iam.gserviceaccount.com"
      ]
      sources = {
        resources = [
          "projects/prj-b-seed_PROJECT_NUMBER",
          "projects/prj-c-secrets_PROJECT_NUMBER",
          "projects/prj-c-billing-export_PROJECT_NUMBER",
          "projects/prj-p-svpc_PROJECT_NUMBER"
        ]
      }
      resources = [
        "projects/prj-p-svpc_PROJECT_NUMBER"
      ]
    }
  }

egress_rules = {
    rule_egress_c_scc = {
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-PROJECT_ID.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-scc-PROJECT_ID.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/prj-c-scc_PROJECT_NUMBER"
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
        "serviceAccount:sa-terraform-org@prj-b-seed-PROJECT_ID.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-logging-PROJECT_ID.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/prj-c-logging-PROJECT_NUMBER"
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
        "serviceAccount:service-CB_1ORG_PROJECT_NUMBER@gcp-sa-cloudbuild.iam.gserviceaccount.com",
        "serviceAccount:CB_1ORG_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" //,
        //the SA bellow can only be added after step 5-app-infra
        //"serviceAccount:CB_4PROJECTS_PROJECT_NUMBER@cloudbuild.gserviceaccount.com",
        //"serviceAccount:sa-tf-cb-bu1-example-app@prj-c-bu1-infra-pipeline-PROJECT_ID.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/prj-b-seed-PROJECT_NUMBER",
        "projects/prj-b-cicd-PROJECT_NUMBER"
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
        "serviceAccount:sa-terraform-org@prj-b-seed-PROJECT_ID.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-billing-export-PROJECT_ID.iam.gserviceaccount.com"
      ]
      sources = {
        resources = [
          "projects/prj-b-seed_PROJECT_NUMBER",
          "projects/prj-c-billing-export_PROJECT_NUMBER"
        ]
      }
      resources = [
        "projects/prj-net-interconnect_PROJECT_NUMBER"
      ]
    }
    rule_ingress_logging = {
      service_name = "bigquery.googleapis.com"
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-PROJECT_ID.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-p-svpc-PROJECT_ID.iam.gserviceaccount.com"
      ]
      sources = {
        resources = [
          "projects/prj-b-seed_PROJECT_NUMBER",
          "projects/prj-c-secrets_PROJECT_NUMBER",
          "projects/prj-c-billing-export_PROJECT_NUMBER",
          "projects/prj-p-svpc_PROJECT_NUMBER"
        ]
      }
      resources = [
        "projects/prj-p-svpc_PROJECT_NUMBER"
      ]
    }
  }

egress_rules_dry_run = {
    rule_egress_c_scc = {
      identities = [
        "serviceAccount:sa-terraform-org@prj-b-seed-PROJECT_ID.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-scc-PROJECT_ID.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/prj-c-scc_PROJECT_NUMBER"
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
        "serviceAccount:sa-terraform-org@prj-b-seed-PROJECT_ID.iam.gserviceaccount.com",
        "serviceAccount:project-service-account@prj-c-logging-PROJECT_ID.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/prj-c-logging-PROJECT_NUMBER"
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
        "serviceAccount:service-CB_1ORG_PROJECT_NUMBER@gcp-sa-cloudbuild.iam.gserviceaccount.com",
        "serviceAccount:CB_1ORG_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" //,
        //the SA bellow can only be added after step 5-app-infra
        //"serviceAccount:CB_4PROJECTS_PROJECT_NUMBER@cloudbuild.gserviceaccount.com",
        //"serviceAccount:sa-tf-cb-bu1-example-app@prj-c-bu1-infra-pipeline-PROJECT_ID.iam.gserviceaccount.com"
      ]
      resources = [
        "projects/prj-b-seed-PROJECT_NUMBER",
        "projects/prj-b-cicd-PROJECT_NUMBER"
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

resource "random_id" "random_access_level_suffix" {
  byte_length = 2
}

module "access_level" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 7.0.0"

  description = "${local.prefix} Access Level for use in an enforced perimeter"
  policy      = var.access_context_manager_policy_id
  name        = local.access_level_name
  members     = var.members
}

module "access_level_dry_run" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 7.0.0"

  description = "${local.prefix} Access Level for testing with a dry run perimeter"
  policy      = var.access_context_manager_policy_id
  name        = local.access_level_name_dry_run
  members     = var.members_dry_run
}

module "regular_service_perimeter" {
  #source = "git::https://github.com/mariammartins/terraform-google-vpc-service-controls.git//modules/regular_service_perimeter?ref=updt-version-perimeter"
  #source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  #version = "~> 7.0.0"
  #source = "git::https://github.com/renato-rudnicki/terraform-google-vpc-service-controls.git//modules/regular_service_perimeter"
  source = "git::https://github.com/daniel-cit/terraform-google-vpc-service-controls.git//modules/regular_service_perimeter?ref=fix-directional-rules"

  policy         = var.access_context_manager_policy_id
  perimeter_name = local.perimeter_name
  description    = "Default VPC Service Controls perimeter"

  # configurations for a perimeter in enforced mode.
  access_levels           = var.enforce_vpcsc ? [module.access_level.name] : []
  restricted_services     = var.enforce_vpcsc ? var.restricted_services : []
  vpc_accessible_services = var.enforce_vpcsc ? ["*"] : []
  ingress_policies        = var.enforce_vpcsc ? var.ingress_policies : []
  egress_policies         = var.enforce_vpcsc ? var.egress_policies : []
  resources               = var.enforce_vpcsc ? var.resources : []

  # configurations for a perimeter in dry run mode.
  access_levels_dry_run           = [module.access_level_dry_run.name]
  restricted_services_dry_run     = var.restricted_services_dry_run
  vpc_accessible_services_dry_run = ["*"]
  ingress_policies_dry_run        = var.ingress_policies_dry_run
  egress_policies_dry_run         = var.egress_policies_dry_run
  resources_dry_run               = var.resources_dry_run
}

resource "time_sleep" "wait_vpc_sc_propagation" {
  create_duration = "60s"

  depends_on = [module.regular_service_perimeter]
}

resource "google_access_context_manager_service_perimeter_ingress_policy" "ingress_policies_CB" {
  perimeter = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"
  ingress_from {
    identity_type = ""
    identities = [
      "serviceAccount:service-623969658122@gcp-sa-cloudbuild.iam.gserviceaccount.com",
      "serviceAccount:623969658122@cloudbuild.gserviceaccount.com",
      "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com"//,
      //the SAs bellow can only be added after step 5-app-infra
      //"serviceAccount:cloudbuild_BU1_project_number@cloudbuild.gserviceaccount.com",
      //"serviceAccount:sa-tf-cb-bu1-example-app@prj-c-bu1-infra-pipeline-PROJECT_ID.iam.gserviceaccount.com"
    ]
    sources {
      access_level = "*"
    }
  }
  ingress_to {
    resources = ["*"]

    operations {
      service_name = "*"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_access_context_manager_service_perimeter_dry_run_ingress_policy" "ingress_policies_dry_run_CB" {
  perimeter = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"
  ingress_from {
    identity_type = ""
    identities = [
      "serviceAccount:service-623969658122@gcp-sa-cloudbuild.iam.gserviceaccount.com",
      "serviceAccount:623969658122@cloudbuild.gserviceaccount.com",
      "serviceAccount:sa-terraform-org@prj-b-seed-3b72.iam.gserviceaccount.com"//,
      //the SAs bellow can only be added after step 5-app-infra
      //"serviceAccount:cloudbuild_BU1_project_number@cloudbuild.gserviceaccount.com",
      //"serviceAccount:sa-tf-cb-bu1-example-app@prj-c-bu1-infra-pipeline-PROJECT_ID.iam.gserviceaccount.com"
    ]
    sources {
      access_level = "*"
    }
  }
  ingress_to {
    resources = ["*"]

    operations {
      service_name = "*"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "google_access_context_manager_service_perimeter_ingress_policy" "ingress_policies" {
  for_each  = local.ingress_rules

  perimeter = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"

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
}

resource "google_access_context_manager_service_perimeter_dry_run_ingress_policy" "ingress_policies_dry_run" {
  for_each  = local.ingress_rules_dry_run

  perimeter = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"

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
}

resource "google_access_context_manager_service_perimeter_egress_policy" "egress_policies" {
  for_each  = local.egress_rules

  perimeter = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"

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

resource "google_access_context_manager_service_perimeter_dry_run_egress_policy" "egress_policies_dry_run" {
  for_each  = local.egress_rules_dry_run

  perimeter = "accessPolicies/${var.access_context_manager_policy_id}/servicePerimeters/${local.perimeter_name}"

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

