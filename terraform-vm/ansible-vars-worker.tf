# Export Terraform variable values to an Ansible var_file
resource "local_file" "tf_ansible_vars_file_worker" {
  content = <<-DOC
- name: Add worker to swarm
  docker_swarm:
    state: join
    advertise_addr: swarm-worker
    join_token: "{{ hostvars['${aws_instance.swarm-manager.public_ip}']['swarm_info']['swarm_facts']['JoinTokens']['Worker'] }}"
    remote_addrs: [ '${aws_instance.swarm-manager.public_ip}:2377' ]

    DOC
  filename = "../ansible/roles/swarm-worker/tasks/main.yml"
}