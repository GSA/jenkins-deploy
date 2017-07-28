# Terraform modules

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

See the variables files in the [`networking`](../terraform/modules/networking/vars.tf) and [`instances`](../terraform/modules/instances/vars.tf) modules for more options. See the [example usage](../terraform/aws.tf).
