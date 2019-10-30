// NSX part for NSX-T network.
base_domain = "openshift.test"
nsx_manager = "NSX Manager IP address or FQDN"
nsx_user = "admin"
nsx_password = "password"
t0_router = "T0 Router UUID"
nsx_edge_cluster = "Edge Cluster UUID"
dhcp_server_ip = "IP address for the DHCP server that serves the cluster's VMs"
dhcp_server_prefix = "Server prefix, i.e. 24"
ip_block_cidr = "IP block CIDR for the pods, i.e. 11.0.0.0/24"
ip_pool_cidr = "IP pool CIDR for the cluster VMs, i.e. 192.168.11.0/24"
transport_zone_id = "471ebe3d-a6d7-417c-8390-562e2f485124"
ip_pool_start = "First IP address in the pool, for the Bootstrap VM"
ip_pool_end = "Last IP address in the pool, for the last compute VM"
dns_nameservers = "DNS to serve the cluster, should be available to Bootstrap VM"
logical_switch_ip_address = "Gateway IP address for the cluster network, i.e. 192.168.11.1"
logical_switch_prefix = "For the aboce logical switch, i.e. 24"
logical_switch = "The name of the cluster network, i.e. openshift-net"