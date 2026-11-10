
locals {

  # Buckets with logging enabled
  logging_buckets = {
    for name, bucket in var.buckets :
    name => bucket
    if bucket.logging.enabled
  }

  # Buckets requiring new log groups
  new_log_groups = {
    for name, bucket in local.logging_buckets :
    name => bucket
    if bucket.logging.create_log_group
  }

  # Buckets with lifecycle policies
  lifecycle_buckets = {
    for name, bucket in var.buckets :
    name => bucket
    if length(bucket.lifecycle_rules) > 0
  }

  # Buckets with replication enabled
  replication_buckets = {
    for name, bucket in var.buckets :
    name => bucket
    if bucket.replication.enabled
  }

  # Common freeform tags
  common_freeform_tags = merge(
    var.default_freeform_tags,
    {
      ManagedBy = "Terraform"
    }
  )
}
