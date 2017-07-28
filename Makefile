TERRAFORM_DIR := terraform
PLAYBOOK_DIR := tests
SSH_USER := ec2-user

all: terraform ansible

install_roles:
	cd $(PLAYBOOK_DIR) && ansible-galaxy install -r requirements.yml

.PHONY: terraform
terraform:
	cd $(TERRAFORM_DIR) && terraform apply

INVENTORY_PATH := $(shell which terraform-inventory)
.PHONY: ansible
ansible: install_roles
	cd $(PLAYBOOK_DIR) && TF_STATE=../$(TERRAFORM_DIR)/terraform.tfstate ansible-playbook --inventory-file=$(INVENTORY_PATH) --become --user=$(SSH_USER) test.yml

destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

validate_terraform:
	cd $(TERRAFORM_DIR) && terraform validate

validate_ansible:
	cd $(PLAYBOOK_DIR) && ansible-playbook --syntax-check test.yml

validate: validate_terraform validate_ansible

start_container:
	docker run -it --privileged -d --name remote centos/systemd

test_ci:
	cd $(PLAYBOOK_DIR) && ansible-playbook -i hosts-docker test.yml

test:
	circleci build --job validate_terraform
	# CircleCI CLI doesn't clean up remote containers
	docker rm -f remote || true
	circleci build
	docker rm -f remote
