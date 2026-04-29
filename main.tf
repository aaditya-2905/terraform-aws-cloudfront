module "cloudfront" {
  source = "./modules/cloudfront"

  aliases               = var.aliases
  origin                = var.origin
  origin_group          = var.origin_group
  origin_access_control = var.origin_access_control

  default_cache_behavior = var.default_cache_behavior
  ordered_cache_behavior = var.ordered_cache_behavior

  custom_error_response = var.custom_error_response

  restrictions = var.restrictions

  viewer_certificate = var.viewer_certificate

  response_headers_policy = var.response_headers_policy

  custom_headers = var.custom_headers

  logging_config = var.logging_config
  log_delivery   = var.log_delivery

  vpc_origin = var.vpc_origin

  default_root_object = var.default_root_object

  tags = var.tags
}
