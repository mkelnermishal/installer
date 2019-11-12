variable "base_domain" {
  type = "string"
}

//////NSX-T ///////

variable "use_nsxt_network" {
  type = "string"
  default = "0"
  description = "When setting this variable to 1, NSX components are installed"
}

variable "nsx_manager" {
  type        = "string"
  description = "This is the NSX manager for the environment."
}

variable "nsx_user" {
  type        = "string"
  description = "NSX manager user for the environment."
}

variable "nsx_password" {
  type        = "string"
  description = "NSX manager password"
}

variable "ip_block_cidr" {
  type = "string"
  description = "cidr for the containers ip block to use."
}

variable "ip_pool_start" {
  type = "string"
  description = "First IP address of the cluster VMs, bootstrap VM IP."
}

variable "ip_pool_end" {
  type = "string"
  description = "Last IP address of the cluster VMs, compute VM IP."
}

variable "ip_pool_cidr" {
  type = "string"
  description = "CIDR for the cluster VMs' IP pool."
}

variable "t0_router" {
  type = "string"
    description = "Tier0 Router UUID, required for creating a tier1 router"
}

variable "logical_switch" {
  type = "string"
  description = "Network name for the cluster's VM"
}

variable "nsx_edge_cluster" {
  type = "string"
  description = "NSX edge cluster UUID"
}

variable "dns_nameservers" {
  type = "string"
  description = "DNS server that will be reachable by thebootstrap VM"
}

variable "dhcp_server_ip" {
  type = "string"
  description = "IP address for the DHCP server, created in NSX"
}

variable "dhcp_server_prefix" {
  type = "string"
  description = "DHCP server prefix length"
}

variable "logical_switch_ip_address" {
  type = "string"
  description = "IP address for the network gateway, for cluster VMs"
}

variable "logical_switch_prefix" {
  type = "string"
  description = "Logical switch prefix length"
}

variable "transport_zone_id" {
  type = "string"
  description = "Transport zone UUID, where the cluster will reside"
}