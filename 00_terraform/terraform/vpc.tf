module "vpc" {
  source       = "github.com/terraform-google-modules/terraform-google-network"
  project_id   = var.project_id
  network_name = "tap-${var.environment}-vpc"
  subnets = [{
    subnet_name   = "subnet-01-${var.environment}"
    subnet_ip     = "10.0.0.0/16"
    subnet_region = var.region
  }]
  secondary_ranges = {
    "subnet-01-${var.environment}" = [{
      range_name    = "subnet-01-${var.environment}-secondary-01"
      ip_cidr_range = "10.10.0.0/16"
      }, {
      range_name    = "subnet-01-${var.environment}-secondary-02"
      ip_cidr_range = "10.20.0.0/16"
    }]
  }
}
