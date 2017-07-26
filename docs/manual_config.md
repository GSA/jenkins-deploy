# Manual configuration

The following steps need to be done by hand.

### Access control

1. Follow [the Role-Based Strategy guide](https://plugins.jenkins.io/role-strategy#RoleStrategyPlugin-Userguide).
    * [More information about the various permissions](https://wiki.jenkins.io/display/JENKINS/Matrix-based+security)
1. Create a `developer` role with all but the `Agent` and `SCM` options.
1. Assign the role by adding a `group` called `authenticated`, selecting the `developer` checkbox.

## Credentials

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

## Adding users

For each user:

1. Generate a password. Here's an easy way on Linux:

    ```sh
    cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9!@#\$%^&\*\(\)\+=_' | head -c 64
    ```

1. View the people list.
    1. Click `Manage Jenkins`.
    1. Click `Manage Users`.
    1. If they exist already:
        1. Click their username.
        1. Click `Configure`.
        1. Correct their `Full Name`.
        1. Set their password.
    1. If they don't, create a user for them.
        1. Click `Create User`.
        1. For the `Username`, use the first part of their GSA email. This will ensure that [it matches up to their commits](https://support.cloudbees.com/hc/en-us/articles/204498804-How-People-is-managed-by-Jenkins).
1. Send the password via [Fugacious](https://fugacious.18f.gov/).

## Other

* Subscribe to [Jenkins security advisories](https://jenkins.io/security/).
* When creating jobs/pipelines, don't include any spaces or special characters in the name, as this can break things in confusing ways.
