module "jumphost" {
  name                       = "tap-${var.environment}-jumphost"
  source                     = "terraform-google-modules/bastion-host/google"
  project                    = var.project_id
  zone                       = var.zones[0]
  service_account_name       = "bastion-${var.environment}"
  network                    = module.vpc.network_name
  subnet                     = module.vpc.subnets_names[0]
  image_family               = "ubuntu-2210-amd64"
  image_project              = "ubuntu-os-cloud"
  external_ip                = true
  startup_script             = file("setup.sh")
  fw_name_allow_ssh_from_iap = "tap-${var.environment}-allow-ssh-from-iap-to-tunnel"
}

output "jumphost_name" {
  value = module.jumphost.hostname
}

output "jumphost_zone" {
  value = var.zones[0]
}
