TERRAFORM_DIR := terraform
PLAYBOOK_DIR := tests

all: terraform ansible

install_roles:
	cd $(PLAYBOOK_DIR) && ansible-galaxy install -p roles -r requirements.yml

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
	cd terraform && terraform validate

validate_ansible:
	docker run \
	  -it --rm \
	  --volume=`pwd`:/etc/jenkins-deploy:ro --workdir /etc/jenkins-deploy/tests \
	  geerlingguy/docker-centos7-ansible \
	  ansible-playbook --syntax-check test.yml

test_ansible:
	docker run \
	  -it --rm \
	  --volume=`pwd`:/etc/jenkins-deploy:ro --workdir /etc/jenkins-deploy/tests \
	  geerlingguy/docker-centos7-ansible \
	  ansible-playbook test.yml

test_ansible_ci:
	# Need to run Ansible as separate process, so that systemd is started within the container. Create a random file to store the container ID.
	# https://www.jeffgeerling.com/blog/2016/how-i-test-ansible-configuration-on-7-different-oses-docker
	container_id=`mktemp`
	docker run \
		-d -it --privileged --name ansible \
		--volume=`pwd`:/etc/jenkins-deploy:ro \
		--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
		geerlingguy/docker-centos7-ansible > $container_id
	sleep 3
	# https://circleci.com/docs/1.0/docker/#docker-exec
	sudo lxc-attach -n $container_id -- bash -c \
		"cd /etc/jenkins-deploy/tests && ansible-playbook --syntax-check test.yml"

# should correspond to test commands in circle.yml
test: validate_terraform validate_ansible test_ansible
