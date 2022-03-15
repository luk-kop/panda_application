## Build AWS resources with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-1.1.7-blueviolet.svg)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS--Provider-4.5.0-blue.svg)](https://www.terraform.io/)

> This part of project is responsible for AWS resources deployment. After successfully deploying the environment in AWS, configure it with Ansible tool (`infrastructure/ansible/playbook.yml`)

### Requirements
* The [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) tool must be installed in order to successfully deploy the AWS resources using it.
* The credentials for AWS account with programmatic access and proper permissions. It can be set up using either the IAM Management Console or the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html) tool.
* The SSH **Key Pair** resource in proper AWS region (default `us-east-1`) should be created. The **Key Pair's** name should be placed in `panda.tfvars` file (`aws_key_name` var) and will bu used by Ansible tool after environmnet deployment for configuration management.


### Build environment
> Note: Be careful when using the `-auto-approve` switch with the `terraform apply` and `terraform destroy` commands. It allows to build or remove a resources without verification and approval.

- All Terraform commands should be run from `infrastructure/terraform` directory.
- Run below commands to initialize a working directory containing Terraform configuration files and build AWS resources:
```bash
terraform init
terraform plan -var-file panda.tfvars
terraform apply -var-file panda.tfvars -auto-approve
```
- Terraform configuration will generate Ansible `invetory` file in `../ansible/inventory` path.

- After run resources deployment and configuration by Ansible (`infrastructure/ansible/playbook.yml`) you can verify that the application is running correctly by using the following command.
```bash
# Replace ELB DNS name
watch -n 1 curl -s panda-dev-alb-xxxxxxxxxx.us-east-1.elb.amazonaws.com
```
> Note: ELB DNS name should be displayed by Terraform after the AWS resource has been successfully created. You can also use `terraform output` command to get it.

### Destroy environment
```bash
terraform destroy -var-file panda.tfvars -auto-approve
```