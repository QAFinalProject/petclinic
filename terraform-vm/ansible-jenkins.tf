# Export Terraform variable values to an Ansible var_file
resource "local_file" "tf_ansible_vars_file_jenkins" {
  content = <<-DOC
pipeline {
    agent any
        environment {
        DOCKER_HUB_CREDS_USR = credentials('DOCKER_HUB_USR')
        DOCKER_HUB_CREDS_PSW = credentials('DOCKER_HUB_PSW')
    }
    stages {
            stage('Terraform') {
                steps {
                    git branch: 'main', url: 'https://github.com/QAFinalProject/petclinic.git'
                    sh '''cd terraform-vm && terraform init
                    terraform apply -auto-approve'''
            }
        }
            stage('Ansible') {
                steps {
                    sh 'ansible-playbook -i $WORKSPACE/ansible/inventory.yaml $WORKSPACE/ansible/playbook.yaml'
            }
        }
        stage('Build Image') {
            steps {
                    sh '''sudo docker image prune
                    sudo docker system prune --all --volumes --force
                    sudo docker-compose build
                    sudo docker login --username $DOCKER_HUB_CREDS_USR --password $DOCKER_HUB_CREDS_PSW
                    sudo docker-compose push'''
            }
        }
            stage('Deploy App') {
                steps {
                    sh '''scp -i ~/.ssh/aws-key-london.pem /home/ubuntu/petclinic/docker-compose.yaml ubuntu@${aws_instance.swarm-manager.public_ip} :/home/ubuntu/
                    ssh -i /home/jenkins/.ssh/aws-key-london.pem ubuntu@${aws_instance.swarm-manager.public_ip}  sudo docker stack deploy --compose-file docker-compose.yaml petclinic-stack'''
            }
        }
            stage('Deploy nginx') {
                steps {
                    sh 'ssh -i /home/jenkins/.ssh/aws-key-london.pem ubuntu@${aws_instance.nginx.public_ip} ./nginx-lb-script.sh'
            }
        }
    }
}

    DOC
  filename = "../Jenkinsfile"
}