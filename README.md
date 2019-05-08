Provisioning VM on vCenter
Prerequisite:
- Must have Terraform installed
- Must have VM template with snapshot already in Vsphere datastore
- This script is tested on terraform 0.11.13

Preparation:

- There are 3 files: vars.tf,provider.tf, vms.tf
- Edit vars.tf to match your environment, for example vcenter IP address. 
- Create terraform.tfvars and define vcenter_username and vcenter_password with value there. For example
vcenter_username = "Administrator@vsphere.local"
vcenter_password = "abcdef"
- Edit vm.tf file to match your environment

How to run:

terraform plan
terraform apply

To destroy:
terraform destroy