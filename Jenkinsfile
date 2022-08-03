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
                    cd terraform-vm && terraform apply -auto-approve'''
            }
        }
            stage('Ansible') {
                steps {
                    git branch: 'main', url: 'https://github.com/QAFinalProject/petclinic.git'
                    sh 'ansible-playbook -i ~/.jenkins/workspace/petclinic/ansible/inventory.yaml ~/.jenkins/workspace/petclinic/ansible/playbook.yaml'
            }
        }
        stage('Build Image') {
            steps {
                    git branch: 'main', url: 'https://github.com/QAFinalProject/petclinic.git'
                    sh '''sudo docker image prune
                    sudo docker system prune --all --volumes --force
                    sudo docker-compose build
                    sudo docker login --username $DOCKER_HUB_CREDS_USR --password $DOCKER_HUB_CREDS_PSW
                    sudo docker-compose push'''
            }
        }
            stage('Deploy App') {
                steps {
                    git branch: 'main', url: 'https://github.com/QAFinalProject/petclinic.git'
                    sh '''scp -i ~/.ssh/aws-key-london.pem /home/ubuntu/petclinic/docker-compose.yaml ubuntu@13.40.135.8 :/home/ubuntu/
                    ssh -i /home/jenkins/.ssh/aws-key-london.pem ubuntu@13.40.135.8  sudo docker stack deploy --compose-file docker-compose.yaml petclinic-stack'''
            }
        }
            stage('Deploy nginx') {
                steps {
                    git branch: 'main', url: 'https://github.com/QAFinalProject/petclinic.git'
                    sh 'ssh -i /home/jenkins/.ssh/aws-key-london.pem ubuntu@13.40.113.81 ./nginx-lb-script.sh'
            }
        }
    }
}