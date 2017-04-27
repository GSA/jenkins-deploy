all: terraform ansible

.PHONY: terraform
terraform:
	cd terraform && terraform apply

INVENTORY_PATH := $(shell which terraform-inventory)
.PHONY: ansible
ansible:
	cd ansible && TF_STATE=../terraform/terraform.tfstate ansible-playbook --inventory-file=$(INVENTORY_PATH) provision.yml
