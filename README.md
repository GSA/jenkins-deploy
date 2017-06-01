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

To create the Jenkins infrastructure, include the [Terraform modules](https://www.terraform.io/docs/modules/index.html) alongside your existing Terraform code:

```hcl
# optional - use if you want a Jenkins-specific security group
module "jenkins_networking" {
  source = "./<path_to_ansible_role>/terraform/modules/networking"

  vpc_id = "${<vpc_id>}"
}

module "jenkins_instances" {
  source = "./<path_to_ansible_role>/terraform/modules/instances"

  subnet_id = "${<subnet_id}"
  # you can pass in a different security group name instead
  vpc_security_group_ids = ["${module.jenkins_networking.sg_id}"]
}
```

See the variables files in the [`networking`](terraform/modules/networking/vars.tf) and [`instances`](terraform/modules/instances/vars.tf) modules for more options. See the [example usage](terraform/aws.tf).

### Ansible role

#### Requirements

None.

#### Role variables

See [`defaults/main.yml`](defaults/main.yml).

#### Dependencies

* [`geerlingguy.jenkins`](https://galaxy.ansible.com/geerlingguy/jenkins/)
* [`geerlingguy.repo-epel`](https://galaxy.ansible.com/geerlingguy/repo-epel/)
* [`williamyeh.oracle-java`](https://galaxy.ansible.com/williamyeh/oracle-java/)
    * Using [a fork](https://github.com/gjedeer/ansible-oracle-java), due to [this issue](https://github.com/William-Yeh/ansible-oracle-java/issues/58)

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
