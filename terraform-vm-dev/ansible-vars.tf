# Export Terraform variable values to an Ansible var_file
resource "local_file" "tf_ansible_vars_file_new" {
  content = <<-DOC
all:
  children:
    manager:
      hosts:
        ${aws_instance.swarm-manager-dev.public_ip}:
    worker:
      hosts:
        ${aws_instance.swarm-worker-dev.public_ip}:
    nginx-lb:
      hosts:
        ${aws_instance.nginx-dev.public_ip}:

  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: '~/.ssh/amz-key-pair.pem'
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
    DOC
  filename = "../ansible-dev/inventory.yaml"
}