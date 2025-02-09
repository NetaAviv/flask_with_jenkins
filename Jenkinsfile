pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' // Change to your AWS region
        ECR_REPO = 'neta/flaskapp'
        IMAGE_TAG = 'latest'
        AWS_ACCOUNT_ID = '767828746131'
        REPO_URL = "767828746131.dkr.ecr.us-east-1.amazonaws.com/neta/flaskapp"
        EC2_USER = 'ec2-user' // Change if using Ubuntu (e.g., 'ubuntu')
        EC2_HOST = '54.211.5.200'
    }

        triggers {
          pollSCM('H/5 * * * *') // Runs every 5 minutes OR use webhook for better performance
        }
    
    stages {

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '767828746131']]) {
                    sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URL'
                    }
                }
            }


        stage('Push Image to AWS ECR') {
            steps {
                script {
                    sh 'docker tag $ECR_REPO:$IMAGE_TAG $REPO_URL:$IMAGE_TAG'
                    sh 'docker push $REPO_URL:$IMAGE_TAG'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    sh '''
                    ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST <<EOF
                    docker pull $REPO_URL:$IMAGE_TAG
                    docker stop flask-app || true
                    docker rm flask-app || true
                    docker run -d --name flask-app -p 5000:5000 $REPO_URL:$IMAGE_TAG
                    EOF
                    '''
                }
            }
        }
    }
}
