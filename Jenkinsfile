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
                          -p 8082:5000 \
                          -e MONGODB_URI="$MONGODB_URI" \
                          $IMAGE_NAME
                        sleep 15
                        curl -f http://localhost:8082
                        docker rm -f finead-todo-test || true
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