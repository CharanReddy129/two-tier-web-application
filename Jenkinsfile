pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github_pat', url: 'https://github.com/CharanReddy129/two-tier-web-application.git'
            }
        }
        stage("build") {
            environment{
                DOCKER_IMAGE = "charanreddy12/two-tier-flaskapp:${BUILD_NUMBER}"
            }
            steps {
                withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/') {
                    sh'''docker build -t ${DOCKER_IMAGE} .
                    docker push ${DOCKER_IMAGE}
                    '''
                    
                }
            }
        }
        stage('code to push') {
            environment {
                GITHUB_CREDENTIALS = credentials('github_pat')
                GITHUB_USER_NAME = "CharanReddy129"
                GITHUB_REPO_NAME = "two-tier-argocd-repo"
            }
            steps {
                sh '''
                rm -rf ${GITHUB_REPO_NAME}
                git clone https://github.com/CharanReddy129/two-tier-argocd-repo.git
                git config --global user.email "charangajulapalli2001@gmail.com"
                git config --global user.name "charan"
                git pull origin main
                sed -i 's|charanreddy12/two-tier-flaskapp:.*|charanreddy12/two-tier-flaskapp:${BUILD_NUMBER}|g' kubernetes/flask_deployment.yml
                git commit -am "updating the image tag to ${BUILD_NUMBER} in flask_deployment.yml file"
                git push https://${GITHUB_CREDENTIALS}@github.com/${GITHUB_USER_NAME}/${GITHUB_REPO_NAME} HEAD:main
                '''
            }
        }
    }
}
