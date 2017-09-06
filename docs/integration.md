# Example configuration

If you want to create a standalone Jenkins with the example out-of-the-box configuration provided in this repository, do the following:

### Setup

1. Install dependencies.
    * [Terraform](https://www.terraform.io/)
    * [Ansible](http://docs.ansible.com/ansible/intro_installation.html)
    * [Terraform Inventory](https://github.com/adammck/terraform-inventory)
1. [Configure Terraform.](https://www.terraform.io/docs/providers/aws/#authentication)
1. Initialize Terraform.

    ```sh
    cd terraform
    terraform init
    ```

1. Create an Ansible secrets file.

    ```sh
    cp tests/secrets-example.yml tests/group_vars/all/secrets.yml
    # set values for the variables
    ```

### Usage

Simple! Just run `make`. Use `make destroy` to tear it down.
