resource "aws_cloudfront_origin_access_control" "this" {
  for_each = var.origin_access_control

  name                              = each.key
  description                       = try(each.value.description, null)
  origin_access_control_origin_type = each.value.origin_type
  signing_behavior                  = each.value.signing_behavior
  signing_protocol                  = each.value.signing_protocol
}

locals {
  origins = {
    for k, v in var.origin :
    k => merge(v, {
      origin_access_control_id = try(
        aws_cloudfront_origin_access_control.this[v.oac_key].id,
        null
      )
    })
  }
}

module "this" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = var.aliases

  origin       = local.origins
  origin_group = var.origin_group

  default_cache_behavior = var.default_cache_behavior
  ordered_cache_behavior = var.ordered_cache_behavior

  custom_error_response = var.custom_error_response

  restrictions = var.restrictions

  viewer_certificate = var.viewer_certificate

  response_headers_policies = var.response_headers_policy

  logging_config = var.logging_config

  default_root_object = var.default_root_object

  tags = var.tags
}
