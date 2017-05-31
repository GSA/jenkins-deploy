# Jenkins Bootstrap

This repository is reusable deployment code/configuration of Jenkins, which gets you up and running with a production-grade Jenkins quickly.

## Integration

If you want to create a standalone Jenkins with the out-of-the-box configuration provided in this repository, do the following:

### Setup

1. Install dependencies.
    * [Terraform](https://www.terraform.io/)
    * [Ansible](http://docs.ansible.com/ansible/intro_installation.html)
    * [Terraform Inventory](https://github.com/adammck/terraform-inventory)
1. [Configure Terraform.](https://www.terraform.io/docs/providers/aws/#authentication)
1. Create an Ansible secrets file.

    ```sh
    cp tests/secrets-example.yml tests/group_vars/all/secrets.yml
    # set values for the variables
    ```

### Usage

Simple! Just run `make`. Use `make destroy` to tear it down.

## Reusable pieces

### Terraform modules

To create the Jenkins infrastructure, include the [Terraform modules](https://www.terraform.io/docs/modules/index.html) alongside your existing Terraform code:

```hcl
# optional - use if you want a Jenkins-specific security group
module "jenkins_networking" {
  source = "./<path_to_ansible_role>/terraform/modules/networking"
}

module "jenkins_instances" {
  source = "./<path_to_ansible_role>/terraform/modules/instances"
  # you can pass in a different security group name instead
  security_groups = ["${module.jenkins_networking.sg_name}"]
}
```

See the variables files in the [`networking`](terraform/modules/networking/vars.tf) and [`instances`](terraform/modules/instances/vars.tf) modules for more options. [Overrides](https://www.terraform.io/docs/configuration/override.html) can also be used for greater customization.

### Ansible role

#### Requirements

None.

#### Role variables

See [`defaults/main.yml`](defaults/main.yml). Required variables:

* SSL configuration - use variables for one of [these options](https://github.com/jdauphant/ansible-role-ssl-certs#examples)

#### Dependencies

* [`geerlingguy.jenkins`](https://galaxy.ansible.com/geerlingguy/jenkins/)
* [`geerlingguy.nginx`](https://galaxy.ansible.com/geerlingguy/nginx/)
* [`geerlingguy.repo-epel`](https://galaxy.ansible.com/geerlingguy/repo-epel/)
* [`jdauphant.ssl-certs`](https://galaxy.ansible.com/jdauphant/ssl-certs/)

#### Usage

```yaml
# requirements.yml
- src: https://github.com/GSA/jenkins-deploy
  name: gsa.jenkins

# playbook.yml
- hosts: jenkins
  roles:
    - gsa.jenkins
```

## License

CC0
