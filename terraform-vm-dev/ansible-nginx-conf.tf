# Export Terraform variable values to an Ansible var_file
resource "local_file" "tf_ansible_vars_file_nginx" {
  content = <<-DOC
events {}
http {
    server {
        listen 80;
        location / {
            proxy_pass "http://${aws_instance.swarm-manager-dev.public_ip}:8080/";
       }
       location /api {
            proxy_pass "http://${aws_instance.swarm-manager-dev.public_ip}:9966/";
       }
    }
}
    DOC
  filename = "../nginx.conf"
}