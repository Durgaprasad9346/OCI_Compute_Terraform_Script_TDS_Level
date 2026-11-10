########################################
# OCI Region
########################################

region = "ap-hyderabad-1"


########################################
# Environment
########################################

environment = "dev"


########################################
# Default Compartment
########################################

default_compartment_id = "ocid1.tenancy.oc1..aaaaaaaafhdxwnqamamnvcsnmudrsskljf7ifls2yegl5rcgx4hllgthsm5q"


########################################
# Defined Tags
########################################

default_defined_tags = {
  "maxlife.Project" = "DAKS"
}


########################################
# Freeform Tags
########################################

default_freeform_tags = {
  ManagedBy   = "Terraform"
  Environment = "dev"
}


########################################
# Object Storage
########################################

buckets = {

  "OCI-test-2.0" = {

    # Bucket Configuration
    versioning   = "Enabled"
    storage_tier = "Standard"


    # Lifecycle Policies
    lifecycle_rules = [

      {
        name        = "archive-after-30-days"
        action      = "ARCHIVE"
        target      = "objects"
        time_amount = 30
        time_unit   = "DAYS"
        is_enabled  = true
      },

      {
        name        = "delete-after-120-days"
        action      = "DELETE"
        target      = "objects"
        time_amount = 120
        time_unit   = "DAYS"
        is_enabled  = true
      },

      {
        name        = "delete-previous-versions"
        action      = "DELETE"
        target      = "previous-object-versions"
        time_amount = 120
        time_unit   = "DAYS"
        is_enabled  = true
      },

      {
        name        = "abort-incomplete-uploads"
        action      = "ABORT"
        target      = "multipart-uploads"
        time_amount = 7
        time_unit   = "DAYS"
        is_enabled  = true
      }

    ]


    # Retention Rules
    retention_rules = [

          ]


    # Logging Configuration
    logging = {
      enabled               = true
      create_log_group      = true
      log_group_name        = "terraform-object-storage-logs"
      log_name              = "terraform-test-bucket-write-log"
      log_category          = "write"
      retention_duration    = 90
    }


    # Cross-Region Replication
    replication = {
      enabled = false
    }

  }

}
