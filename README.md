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

For any variables marked `sensitive`, you are strongly encouraged to store the values in an [Ansible Vault](https://docs.ansible.com/ansible/playbooks_vault.html).

##### Required

* `jenkins_external_hostname`
* SSH key - information about how to generate in [Usage](#usage) section below.
    * `jenkins_ssh_key_passphrase` (sensitive)
    * `jenkins_ssh_private_key_data` (sensitive)
    * `jenkins_ssh_public_key_data`
* [SSL configuration](https://github.com/jdauphant/ansible-role-ssl-certs#examples) (sensitive)
    * The [key data](https://github.com/jdauphant/ansible-role-ssl-certs#example-to-deploy-a-ssl-certificate-stored-in-variables) approach is recommended.

##### Optional

See [`defaults/main.yml`](defaults/main.yml).

#### Dependencies

* [`geerlingguy.jenkins`](https://galaxy.ansible.com/geerlingguy/jenkins/)
* [`geerlingguy.nginx`](https://galaxy.ansible.com/geerlingguy/nginx/)
* [`geerlingguy.repo-epel`](https://galaxy.ansible.com/geerlingguy/repo-epel/)
* [`jdauphant.ssl-certs`](https://galaxy.ansible.com/jdauphant/ssl-certs/)
* [`williamyeh.oracle-java`](https://galaxy.ansible.com/williamyeh/oracle-java/)
    * Using [a fork](https://github.com/gjedeer/ansible-oracle-java), due to [this issue](https://github.com/William-Yeh/ansible-oracle-java/issues/58)

#### Usage

1. Generate an SSH key.

    ```sh
    ssh-keygen -t rsa -b 4096 -f temp.key -C "group-email+jenkins@some.gov"
    # enter a passphrase - store in Vault as vault_jenkins_ssh_key_passphrase

    cat temp.key
    # store in Vault as vault_jenkins_ssh_private_key_data

    cat temp.key.pub
    # store as jenkins_ssh_public_key_data

    rm temp.key*
    ```

1. Include the role and required variables. Example:

    ```yaml
    # requirements.yml
    - src: https://github.com/GSA/jenkins-deploy
      name: gsa.jenkins

    # group_vars/all/vars.yml
    jenkins_ssh_user: jenkins
    jenkins_ssh_public_key_data: |
      ssh-rsa ... group-email+jenkins@some.gov

    # group_vars/jenkins/vars.yml
    jenkins_external_hostname: ...
    jenkins_ssh_key_passphrase: "{{ vault_jenkins_ssh_key_passphrase }}"
    jenkins_ssh_private_key_data: "{{ vault_jenkins_ssh_private_key_data }}"
    ssl_certs_local_cert_data: "{{ vault_ssl_certs_local_cert_data }}"
    ssl_certs_local_privkey_data: "{{ vault_ssl_certs_local_privkey_data }}"

    # group_vars/jenkins/vault.yml (encrypted)
    vault_jenkins_ssh_key_passphrase: ...
    vault_jenkins_ssh_private_key_data: |
      -----BEGIN RSA PRIVATE KEY-----
      ...
      -----END RSA PRIVATE KEY-----
    vault_ssl_certs_local_cert_data: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
    vault_ssl_certs_local_privkey_data: |
      -----BEGIN RSA PRIVATE KEY-----
      ...
      -----END RSA PRIVATE KEY-----

    # playbooks/jenkins.yml
    - hosts: jenkins
      become: true
      roles:
        - gsa.jenkins

    # playbooks/other.yml
    # hosts that Jenkins is going to run playbooks against
    - hosts: other
      become: true
      tasks:
        - name: Create Jenkins user
          user:
            name: "{{ jenkins_ssh_user }}"
            group: wheel
        - name: Set up SSH key for Jenkins
          authorized_key:
            user: "{{ jenkins_ssh_user }}"
            key: "{{ jenkins_ssh_public_key_data }}"
        # ...other host setup tasks...
    ```

1. Run the Terraform (if applicable) and the playbook.
1. Ensure you can log into Jenkins (at `jenkins_external_hostname`).
1. Add the Credentials in Jenkins (manually).
    1. Visit `https://JENKINS_EXTERNAL_HOSTNAME/credentials/store/system/domain/_/newCredentials`
    1. Fill in the form:
        1. `Kind`: `SSH Username with private key`
        1. `Scope`: `Global (Jenkins, nodes, items, all child items, etc)`
        1. `Username`: `jenkins`
        1. `Private Key`: `From the Jenkins master ~/.ssh`
        1. `Passphrase`: the value from `vault_jenkins_ssh_key_passphrase`
        1. `ID`: `jenkins-ssh-key`
        1. `Description`: (empty)
    1. Click `OK`.
    1.  Use these Credentials from your Jobs.

## Development

To test locally:

1. [Install Docker.](https://www.docker.com/community-edition#/download)
1. Run the installation within a container.

    ```sh
    make test
    ```

## License

CC0
