data "vsphere_datacenter" "dc" {
    name = "site1-ninjago"
}

data "vsphere_datastore" "datastore" {
  name          = "esx11-hdd"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Cluster1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Define NIC Card of VM
data "vsphere_network" "network01" {
  name          = "mgmt-vlan11"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network02" {
  name          = "mgmt-vlan12"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu1604-temp"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  count = 20
  name             = "terraform-vm-${count.index + 1}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 2048
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  wait_for_guest_net_timeout = 0

  network_interface {
    network_id   = "${data.vsphere_network.network01.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  network_interface {
    network_id   = "${data.vsphere_network.network02.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[1]}"
  }


  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone { 
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone = true
    customize {
      linux_options {
        host_name = "terraform-vm-${count.index + 1}"
        domain = "ninjago.local"
      }

      network_interface {
        ipv4_address= "192.168.11.${201 + count.index}"
        ipv4_netmask = "24"
      }

      # declare second interface for DHCP
      network_interface {
        ipv4_address= "1.1.1.${201 + count.index}"
        ipv4_netmask = "24"
      }

    }
  }
  
}

