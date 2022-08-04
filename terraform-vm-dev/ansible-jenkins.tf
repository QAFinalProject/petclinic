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
        stage('Clean up WS') {
            steps {
                // Clean before build
                cleanWs()
                }
            }
        stage('Ansible') {
            steps {
                git branch: 'dev-env-jon', url: 'https://github.com/QAFinalProject/petclinic.git'
                sh 'ansible-playbook -i $WORKSPACE/ansible-dev/inventory.yaml $WORKSPACE/ansible-dev/playbook.yaml'
                }
            }
        stage('Build Image') {
            steps {
                sh '''sudo docker image prune
                sudo docker system prune --all --volumes --force
                sudo docker-compose -f docker-compose-dev.yaml build
                sudo docker login --username $DOCKER_HUB_CREDS_USR --password $DOCKER_HUB_CREDS_PSW
                sudo docker-compose -f docker-compose-dev.yaml push'''
                }
            }
        stage('Deploy App') {
            steps {
                sh 'ssh -i /home/jenkins/.ssh/amz-key-pair.pem ubuntu@${aws_instance.swarm-manager-dev.public_ip}  sudo docker stack deploy --compose-file docker-compose-dev.yaml petclinic-stack'
                }
            }
        stage('Deploy nginx') {
            steps {
                sh 'ssh -i /home/jenkins/.ssh/amz-key-pair.pem ubuntu@${aws_instance.nginx-dev.public_ip} ./nginx-lb-script.sh'
            }
        }
    }
}

    DOC
  filename = "../Jenkinsfile"
}