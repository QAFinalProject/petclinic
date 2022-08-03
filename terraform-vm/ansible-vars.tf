# Export Terraform variable values to an Ansible var_file
resource "local_file" "tf_ansible_vars_file_new" {
  content = <<-DOC
all:
  children:
    manager:
      hosts:
        ${aws_instance.swarm-manager.public_ip}:
    worker:
      hosts:
        ${aws_instance.swarm-worker.public_ip}:
    nginx-lb:
      hosts:
        ${aws_instance.nginx.public_ip}:

  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: '~/.ssh/aws-key-london.pem'
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
    DOC
  filename = "~/.jenkins/workspace/petclinic-terraform/"
}