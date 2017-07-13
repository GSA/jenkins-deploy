TERRAFORM_DIR := terraform
PLAYBOOK_DIR := tests

all: terraform ansible

install_roles:
	cd $(PLAYBOOK_DIR) && ansible-galaxy install -r requirements.yml

.PHONY: terraform
terraform:
	cd $(TERRAFORM_DIR) && terraform apply

INVENTORY_PATH := $(shell which terraform-inventory)
.PHONY: ansible
ansible: install_roles
	cd $(PLAYBOOK_DIR) && TF_STATE=../$(TERRAFORM_DIR)/terraform.tfstate ansible-playbook --inventory-file=$(INVENTORY_PATH) test.yml

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

validate_terraform:
	cd $(TERRAFORM_DIR) && terraform validate

validate_ansible:
	cd $(PLAYBOOK_DIR) && ansible-playbook --syntax-check test.yml

validate: validate_terraform validate_ansible

test: validate
	docker run \
	  -it --privileged --rm \
	  --volume=`pwd`:/etc/jenkins-deploy:ro --workdir /etc/jenkins-deploy/tests \
	  geerlingguy/docker-centos7-ansible \
	  ansible-playbook test.yml
