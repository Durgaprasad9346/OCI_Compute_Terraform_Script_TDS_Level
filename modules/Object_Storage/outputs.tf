
# =====================================================
# 1. BUCKET OUTPUTS
# =====================================================

output "bucket_ids" {
  description = "Map of Object Storage bucket names to OCIDs."

  value = {
    for name, bucket in oci_objectstorage_bucket.this :
    name => bucket.id
  }
}

output "bucket_names" {
  description = "Map of logical bucket names to actual bucket names."

  value = {
    for name, bucket in oci_objectstorage_bucket.this :
    name => bucket.name
  }
}

output "bucket_details" {
  description = "Object Storage bucket details."

  value = {
    for name, bucket in oci_objectstorage_bucket.this :
    name => {
      id                    = bucket.id
      name                  = bucket.name
      namespace             = bucket.namespace
      compartment_id        = bucket.compartment_id
      access_type           = bucket.access_type
      versioning            = bucket.versioning
      storage_tier          = bucket.storage_tier
      object_events_enabled = bucket.object_events_enabled
    }
  }
}


# =====================================================
# 2. LOG GROUP OUTPUTS
# =====================================================

output "log_group_ids" {
  description = "New and existing log group OCIDs."

  value = merge(
    {
      for name, group in oci_logging_log_group.this :
      name => group.id
    },
    {
      for name, bucket in local.logging_buckets :
      name => bucket.logging.existing_log_group_id
      if !bucket.logging.create_log_group
    }
  )
}


# =====================================================
# 3. LOG OUTPUTS
# =====================================================

output "log_ids" {
  description = "Object Storage service log OCIDs."

  value = {
    for name, log in oci_logging_log.this :
    name => log.id
  }
}


# =====================================================
# 4. LIFECYCLE POLICY OUTPUTS
# =====================================================

output "lifecycle_policy_ids" {
  description = "Object Storage lifecycle policy OCIDs."

  value = {
    for name, policy in oci_objectstorage_object_lifecycle_policy.this :
    name => policy.id
  }
}


# =====================================================
# 5. REPLICATION POLICY OUTPUTS
# =====================================================

output "replication_policy_ids" {
  description = "Object Storage replication policy OCIDs."

  value = {
    for name, policy in oci_objectstorage_replication_policy.this :
    name => policy.id
  }
}

output "replication_policy_status" {
  description = "Object Storage replication policy status."

  value = {
    for name, policy in oci_objectstorage_replication_policy.this :
    name => {
      status         = policy.status
      status_message = policy.status_message
    }
  }
}
