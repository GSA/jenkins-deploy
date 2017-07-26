# Jenkins Bootstrap [![CircleCI](https://circleci.com/gh/GSA/jenkins-deploy.svg?style=svg)](https://circleci.com/gh/GSA/jenkins-deploy)

This repository is reusable deployment code/configuration of Jenkins, which gets you up and running with a production-grade Jenkins quickly.

## Integration

See [the documentation](docs/integration.md).

## Reusable pieces

### Terraform modules

See [the documentation](docs/terraform.md).

### Ansible role

#### Requirements

None.

#### Role variables

For any variables marked `sensitive`, you are strongly encouraged to store the values in an [Ansible Vault](https://docs.ansible.com/ansible/playbooks_vault.html).

##### Required

* `jenkins_admin_password` - store in a [Vault](https://docs.ansible.com/ansible/playbooks_vault.html)
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
* [`gsa.https-proxy`](https://github.com/GSA/ansible-https-proxy)
* [`srsp.oracle-java`](https://galaxy.ansible.com/srsp/oracle-java/)

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
1. Follow the [manual configuration steps](docs/manual_config.md)

## License

CC0
