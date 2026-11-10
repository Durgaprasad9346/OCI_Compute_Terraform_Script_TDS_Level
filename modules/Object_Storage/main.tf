
# =====================================================
# 1. GET OBJECT STORAGE NAMESPACE
# =====================================================

data "oci_objectstorage_namespace" "this" {
  compartment_id = var.default_compartment_id
}


# =====================================================
# 2. CREATE OBJECT STORAGE BUCKETS
# =====================================================

resource "oci_objectstorage_bucket" "this" {

  for_each = var.buckets

  compartment_id = coalesce(
    each.value.compartment_id,
    var.default_compartment_id
  )

  namespace = data.oci_objectstorage_namespace.this.namespace

  name = coalesce(
    each.value.name,
    each.key
  )

  # Security: Disable public access
  access_type = "NoPublicAccess"

  # Enable object events
  object_events_enabled = true

  # Bucket configuration
  versioning   = each.value.versioning
  storage_tier = each.value.storage_tier
  kms_key_id   = each.value.kms_key_id
  metadata     = each.value.metadata

  # Tags
  defined_tags = merge(
    var.default_defined_tags,
    each.value.defined_tags
  )

  freeform_tags = merge(
    local.common_freeform_tags,
    each.value.freeform_tags
  )

  # Retention rules
  dynamic "retention_rules" {

    for_each = each.value.retention_rules

    content {

      display_name = retention_rules.value.display_name

      duration {
        time_amount = retention_rules.value.time_amount
        time_unit   = retention_rules.value.time_unit
      }

      time_rule_locked = retention_rules.value.time_rule_locked
    }
  }
}


# =====================================================
# 3. OBJECT STORAGE LIFECYCLE POLICIES
# =====================================================

resource "oci_objectstorage_object_lifecycle_policy" "this" {

  for_each = local.lifecycle_buckets

  namespace = data.oci_objectstorage_namespace.this.namespace

  bucket = coalesce(
    each.value.name,
    each.key
  )

  dynamic "rules" {

    for_each = each.value.lifecycle_rules

    content {

      name        = rules.value.name
      action      = rules.value.action
      time_amount = rules.value.time_amount
      time_unit   = rules.value.time_unit
      target      = rules.value.target
      is_enabled  = rules.value.is_enabled

      dynamic "object_name_filter" {

        for_each = rules.value.object_name_filter == null ? [] : [
          rules.value.object_name_filter
        ]

        content {

          inclusion_prefixes = object_name_filter.value.inclusion_prefixes
          inclusion_patterns = object_name_filter.value.inclusion_patterns
          exclusion_patterns = object_name_filter.value.exclusion_patterns
        }
      }
    }
  }

  depends_on = [
    oci_objectstorage_bucket.this
  ]
}


# =====================================================
# 4. CREATE NEW LOG GROUPS
# =====================================================

resource "oci_logging_log_group" "this" {

  for_each = local.new_log_groups

  compartment_id = coalesce(
    each.value.compartment_id,
    var.default_compartment_id
  )

  display_name = coalesce(
    each.value.logging.log_group_name,
    "${coalesce(each.value.name, each.key)}-logs"
  )

  description = "Object Storage logs managed by Terraform"

  defined_tags = var.default_defined_tags
  freeform_tags = local.common_freeform_tags
}


# =====================================================
# 5. CONFIGURE OBJECT STORAGE LOGGING
# =====================================================

resource "oci_logging_log" "this" {

  for_each = local.logging_buckets

  display_name = coalesce(
    each.value.logging.log_name,
    "${coalesce(each.value.name, each.key)}-write-log"
  )

  log_group_id = (
    each.value.logging.create_log_group
    ? oci_logging_log_group.this[each.key].id
    : each.value.logging.existing_log_group_id
  )

  log_type = "SERVICE"

  is_enabled = true

  retention_duration = each.value.logging.retention_duration

  configuration {

    compartment_id = coalesce(
      each.value.compartment_id,
      var.default_compartment_id
    )

    source {

      category    = each.value.logging.log_category
      resource    = coalesce(each.value.name, each.key)
      service     = "objectstorage"
      source_type = "OCISERVICE"
    }
  }

  defined_tags = var.default_defined_tags
  freeform_tags = local.common_freeform_tags

  depends_on = [
    oci_objectstorage_bucket.this,
    oci_logging_log_group.this
  ]
}


# =====================================================
# 6. CROSS-REGION REPLICATION POLICIES
# =====================================================

resource "oci_objectstorage_replication_policy" "this" {

  for_each = local.replication_buckets

  namespace = data.oci_objectstorage_namespace.this.namespace

  bucket = coalesce(
    each.value.name,
    each.key
  )

  name = each.value.replication.policy_name

  destination_region_name = (
    each.value.replication.destination_region_name
  )

  destination_bucket_name = (
    each.value.replication.destination_bucket_name
  )

  depends_on = [
    oci_objectstorage_bucket.this
  ]
}
