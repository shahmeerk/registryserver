pipeline {
    agent any

    environment {
        APP_NAME = 'registry-server' // Replace with your application name
        IMAGE_TAG = 'latest' // or you can use a dynamic tag, for example, using ${env.BUILD_ID}
        DOCKER_HUB_REPO = 'sk4k/registry-container' // Replace with your Docker Hub username and repository name
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']], // Replace with your branch name
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        url: 'https://github.com/shahmeerk/s-registryserver.git', // Replace with your GitHub repository URL
                        credentialsId: 'github-credentials' // Replace with your GitHub credentials ID stored in Jenkins
                    ]]
                ])
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'Lousy--97', usernameVariable: 'sk4k')]) {
                        sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}
                        '''
                    }
                }
            }
        }
    }
}
