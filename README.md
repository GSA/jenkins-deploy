# Jenkins Bootstrap

This repository is reusable deployment code/configuration of Jenkins, which gets you up and running with a production-grade Jenkins quickly.

## Setup

1. Install dependencies.
    * [Terraform](https://www.terraform.io/)
    * [Ansible](http://docs.ansible.com/ansible/intro_installation.html)
1. [Configure Terraform.](https://www.terraform.io/docs/providers/aws/#authentication)
1. Create an Ansible secrets file.

    ```sh
    mkdir -p tests/group_vars/all
    cp tests/secrets-example.yml tests/group_vars/all/secrets.yml
    # set values for the variables
    ```

## Usage

Simple! Just run `make`. Use `make destroy` to tear it down.

## Ansible role

### Requirements

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

### Role variables

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

### Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

### Example playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- hosts: servers
  roles:
    - role: username.rolename
      x: 42
```

### License

CC0
