provider "vsphere" {
    user = "${var.vcenter_username}"
    password = "${var.vcenter_password}"
    vsphere_server = "${var.vcenter_ip_address}"
    allow_unverified_ssl = true
}