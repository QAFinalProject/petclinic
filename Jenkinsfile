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
                git branch: 'dev-env', url: 'https://github.com/QAFinalProject/petclinic.git'
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
                sh 'ssh -i /home/jenkins/.ssh/aws-key-london.pem ubuntu@13.40.110.119  sudo docker stack deploy --compose-file docker-compose.yaml petclinic-stack'
                }
            }
        stage('Deploy nginx') {
            steps {
                sh 'ssh -i /home/jenkins/.ssh/aws-key-london.pem ubuntu@18.133.138.190 ./nginx-lb-script.sh'
            }
        }
    }
}

