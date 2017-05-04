# Jenkins Bootstrap

This repository is reusable deployment code/configuration of Jenkins, which gets you up and running with a production-grade Jenkins quickly.

## Setup

1. Install dependencies.
    * [Terraform](https://www.terraform.io/)
    * [Ansible](http://docs.ansible.com/ansible/intro_installation.html)
1. [Configure Terraform.](https://www.terraform.io/docs/providers/aws/#authentication)
1. Create an Ansible secrets file.

    ```sh
    mkdir -p ansible/group_vars/all
    cp ansible/secrets-example.yml ansible/group_vars/all/secrets.yml
    # set values for the variables
    ```

## Usage

Simple! Just run `make`. Use `make destroy` to tear it down.
