# Configuration with Ansible

> This part of project is responsible for EC2 instances configuration with Ansible tool (dedicated `panda` role). Should be used only after successfully deploying the environment in AWS by Terraform (in `infrastructure/terraform` dir).

### The `panda` role feautures
- Downloads panda application JAR from artifact repository.
- Creates `systemd.service` unit.
- Starts the application.

### Requirements
- The `inventory` file should be generated by Terraform tool.
- The SSH key previously created in AWS should be placed in path `infrastructure/panda.pem`.
- Maven module requires the `lxml` python library installed on the managed machine.
- Running artifact repository (f.e. Artifactory). The repository details should be stored in `infrastructure/ansible/panda/defaults/main.yml` file.

### Configure environment

- All Ansible commands should be run from `infrastructure/ansible` directory.
- Run below commands to configure EC2 instances created by Terraform tool:
```bash
ansible-playbook -i inventory playbook.yml
```