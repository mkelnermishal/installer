provider "nsxt" {
  host                     = "${var.nsx_manager}"
  username                 = "${var.nsx_user}"
  password                 = "${var.nsx_password}"
  allow_unverified_ssl     = true
  max_retries              = 10
  retry_min_delay          = 500
  retry_max_delay          = 5000
  retry_on_status_codes    = [429, 503]
}

resource "nsxt_logical_tier1_router" "tier1_router" {
  description                 = "RTR1 provisioned by Terraform"
  display_name                = "T1_OCP"
  failover_mode               = "PREEMPTIVE"
  edge_cluster_id             = "${var.nsx_edge_cluster}"
  enable_router_advertisement = true
  advertise_connected_routes  = true
  advertise_static_routes     = true
  advertise_nat_routes        = true
  advertise_lb_vip_routes     = true
  advertise_lb_snat_ip_routes = false
}

resource "nsxt_logical_router_link_port_on_tier0" "link_port_tier0" {
  description       = "TIER0_PORT1 provisioned by Terraform"
  display_name      = "TIER0_PORT1_FROM_T0_TO_T1"
  logical_router_id = "${var.t0_router}"
}

resource "nsxt_logical_router_link_port_on_tier1" "link_port_tier1" {
  description                   = "TIER1_PORT1 provisioned by Terraform"
  display_name                  = "TIER1_PORT1_FROM_T1_TO_T0"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.link_port_tier0.id}"
}

resource "nsxt_logical_switch" "switch1" {
  count             = "${var.use_nsxt_network}"
  admin_state       = "UP"
  description       = "LS1 provisioned by Terraform"
  display_name      = "${var.logical_switch}"
  transport_zone_id = "${var.transport_zone_id}"
  replication_mode  = "MTEP"
}

resource "nsxt_logical_port" "logical_port" {
  admin_state       = "UP"
  description       = "LP1 provisioned by Terraform"
  display_name      = "LP1"
  logical_switch_id = "${nsxt_logical_switch.switch1.id}"
}

resource "nsxt_logical_router_downlink_port" "downlink_port" {
  description                   = "DP1 provisioned by Terraform"
  display_name                  = "T1_DOWNLINK_OCP_LS"
  logical_router_id             = "${nsxt_logical_tier1_router.tier1_router.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.logical_port.id}"
  ip_address                    = "${var.logical_switch_ip_address}/${var.logical_switch_prefix}"
}

resource "nsxt_dhcp_server_profile" "dhcp_profile" {
  description                 = "dhcp_profile provisioned by Terraform"
  display_name                = "dhcp_profile"
  edge_cluster_id             = "${var.nsx_edge_cluster}"
}

resource "nsxt_logical_dhcp_server" "logical_dhcp_server" {
  display_name    = "logical_dhcp_server"
  dhcp_profile_id = "${nsxt_dhcp_server_profile.dhcp_profile.id}"
  dhcp_server_ip  = "${var.dhcp_server_ip}/${var.dhcp_server_prefix}"
  gateway_ip      = "${var.logical_switch_ip_address}"
  domain_name = "${var.base_domain}"
  dns_name_servers = ["${var.dns_nameservers}"]
}

resource "nsxt_logical_dhcp_port" "dhcp_port" {
  admin_state       = "UP"
  description       = "LP1 provisioned by Terraform"
  display_name      = "LP1"
  logical_switch_id = "${nsxt_logical_switch.switch1.id}"
  dhcp_server_id    = "${nsxt_logical_dhcp_server.logical_dhcp_server.id}"
}

resource "nsxt_dhcp_server_ip_pool" "dhcp_ip_pool" {
  display_name = "ip pool"
  description = "ip pool"
  logical_dhcp_server_id = "${nsxt_logical_dhcp_server.logical_dhcp_server.id}"
  gateway_ip = "${var.logical_switch_ip_address}"
  lease_time = 86400
  error_threshold = 100
  warning_threshold = 80
  ip_range {
    start = "${var.ip_pool_start}"
    end   = "${var.ip_pool_end}"
  }
}

resource "nsxt_ip_block" "ip_block" {
  description  = "ip_block provisioned by Terraform"
  display_name = "ip_block"
  cidr         = "${var.ip_block_cidr}"
}