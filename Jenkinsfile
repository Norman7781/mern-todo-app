pipeline {
    agent any

    environment {
        IMAGE_NAME = "degantheman4420/finead-todo-app:latest"
    }

    stages {
        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Verify Container') {
            steps {
                withCredentials([string(credentialsId: 'mongodb-uri', variable: 'MONGODB_URI')]) {
                    sh '''
                        docker rm -f finead-todo-test || true
                        docker run -d --name finead-todo-test \
                            -e MONGODB_URI=$MONGODB_URI \
                            degantheman4420/finead-todo-app:latest
                        sleep 15
                        docker logs finead-todo-test
                        docker exec finead-todo-test wget -qO- http://localhost:5000 || \
                        docker exec finead-todo-test curl -f http://localhost:5000
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker rm -f finead-todo-test || true'
        }
    }
}