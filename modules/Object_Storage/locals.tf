
locals {

  # =====================================================
  # 1. BUCKETS WITH LOGGING ENABLED
  # =====================================================

  logging_buckets = {
    for name, bucket in var.buckets :
    name => bucket
    if bucket.logging.enabled
  }


  # =====================================================
  # 2. BUCKETS REQUIRING NEW LOG GROUPS
  # =====================================================

  new_log_groups = {
    for name, bucket in local.logging_buckets :
    name => bucket
    if bucket.logging.create_log_group
  }


  # =====================================================
  # 3. GENERATE READ AND WRITE LOG CONFIGURATIONS
  # =====================================================

  logging_log_configs = {
    for item in flatten([
      for bucket_key, bucket in local.logging_buckets : [
        for category, enabled in {
          read  = bucket.logging.read_enabled
          write = bucket.logging.write_enabled
        } : {
          key        = "${bucket_key}-${category}"
          bucket_key = bucket_key
          bucket     = bucket
          category   = category
        } if enabled
      ]
    ]) : item.key => item
  }


  # =====================================================
  # 4. BUCKETS WITH LIFECYCLE POLICIES
  # =====================================================

  lifecycle_buckets = {
    for name, bucket in var.buckets :
    name => bucket
    if length(bucket.lifecycle_rules) > 0
  }


  # =====================================================
  # 5. BUCKETS WITH REPLICATION ENABLED
  # =====================================================

  replication_buckets = {
    for name, bucket in var.buckets :
    name => bucket
    if bucket.replication.enabled
  }


  # =====================================================
  # 6. COMMON FREEFORM TAGS
  # =====================================================

  common_freeform_tags = merge(
    var.default_freeform_tags,
    {
      ManagedBy = "Terraform"
    }
  )

}
