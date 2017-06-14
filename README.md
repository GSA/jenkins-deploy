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

See [`defaults/main.yml`](defaults/main.yml). Required variables:

* `jenkins_admin_password` - store in a [Vault](https://docs.ansible.com/ansible/playbooks_vault.html)
* `jenkins_external_hostname`
* [SSL configuration](https://github.com/jdauphant/ansible-role-ssl-certs#examples)
    * Storing [key data](https://github.com/jdauphant/ansible-role-ssl-certs#example-to-deploy-a-ssl-certificate-stored-in-variables) in a Vault is the recommended approach, though you can use the other options.

#### Dependencies

* [`geerlingguy.jenkins`](https://galaxy.ansible.com/geerlingguy/jenkins/)
* [`geerlingguy.nginx`](https://galaxy.ansible.com/geerlingguy/nginx/)
* [`geerlingguy.repo-epel`](https://galaxy.ansible.com/geerlingguy/repo-epel/)
* [`jdauphant.ssl-certs`](https://galaxy.ansible.com/jdauphant/ssl-certs/)
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

## Development

To test locally:

1. [Install Docker.](https://www.docker.com/community-edition#/download)
1. Run the installation within a container.

    ```sh
    make test
    ```

## License

CC0
