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
    mkdir -p tests/group_vars/all
    cp tests/secrets-example.yml tests/group_vars/all/secrets.yml
    # set values for the variables
    ```

### Usage

Simple! Just run `make`. Use `make destroy` to tear it down.

## Reusable pieces

### Terraform modules

The following [Terraform modules](https://www.terraform.io/docs/modules/index.html) are available for including in a larger deployment:

```hcl
module "jenkins_with_security_groups" {
  source = "./<path_to_ansible_role>/terraform/modules/standalone"
}

# or

module "jenkins_using_existing_security_group" {
  source = "./<path_to_ansible_role>/terraform/modules/instances"
  security_groups = ["${something}"]
}
```

### Ansible role

#### Requirements

None.

#### Role variables

See [`defaults/main.yml`](defaults/main.yml).

#### Dependencies

* [`geerlingguy.jenkins`](https://galaxy.ansible.com/geerlingguy/jenkins/)
* [`geerlingguy.repo-epel`](https://galaxy.ansible.com/geerlingguy/repo-epel/)

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
