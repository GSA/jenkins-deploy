# Manual configuration

The following steps need to be done by hand.

1. Add the Credentials in Jenkins.
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
1. Subscribe to [Jenkins security advisories](https://jenkins.io/security/).

When creating jobs/pipelines, don't include any spaces or special characters in the name, as this can break things in confusing ways.
