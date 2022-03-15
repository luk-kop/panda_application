locals {
  project     = "panda"
  environment = "dev"
  name_prefix = "${local.project}-${local.environment}"
}

resource "random_uuid" "some_uuid" {
}
