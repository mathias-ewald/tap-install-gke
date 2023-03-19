module "gke_run" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = "tap-${var.environment}-run"
  region                     = var.region
  regional                   = true
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names[0]
  ip_range_pods              = "subnet-01-${var.environment}-secondary-01"
  ip_range_services          = "subnet-01-${var.environment}-secondary-02"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = false
  remove_default_node_pool   = true
  kubernetes_version         = "1.24.9-gke.3200"
  cluster_autoscaling = {
    enabled       = false
    max_cpu_cores = 0
    min_cpu_cores = 0
    max_memory_gb = 0
    min_memory_gb = 0
    gpu_resources = []
    auto_repair   = true
    auto_upgrade  = false
  }
  node_pools = [
    {
      name                   = "default-node-pool"
      machine_type           = "e2-standard-8"
      node_locations         = join(",", var.zones)
      min_count              = 1
      max_count              = 1
      local_ssd_count        = 0
      disk_size_gb           = 100
      disk_type              = "pd-standard"
      image_type             = "COS_CONTAINERD"
      auto_repair            = true
      auto_upgrade           = true
      create_service_account = true
      preemptible            = false
      autoscaling            = true
      initial_node_count     = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []
    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}
    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}
    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []
    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []
    default-node-pool = [
      "default-node-pool",
    ]
  }
}

output "run_cluster_name" {
  value = module.gke_run.name
}
