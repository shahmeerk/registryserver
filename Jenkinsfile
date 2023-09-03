pipeline {
    agent any

    tools {
        maven 'M3'
    }
    environment {
        APP_NAME = 'registry-server'
        IMAGE_TAG = 'latest'
        DOCKER_HUB_REPO = 'sk4k/registry-container'
        KUBECONFIG_FILE = 'kubeconfig'
        DEPLOYMENT_FILE = 'deployment.yaml'
    }
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-credentials', url: 'https://github.com/shahmeerk/s-registryserver.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Run Automated Tests') {
                    steps {
                        sh 'mvn test'
                    }
        }
        stage('SonarQube Scanning') {
                    steps {
                        script {
                            withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                                sh(script: "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin", returnStdout: true).trim()
                                sh "docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}"
                            }
                        }
                    }
                }
                stage('Checkmarx Scanning') {
                            steps {
                                script {
                                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                                        sh(script: "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin", returnStdout: true).trim()
                                        sh "docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}"
                                    }
                                }
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
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh(script: "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin", returnStdout: true).trim()
                        sh "docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}"
                    }
                }
            }
        }
        stage('Terraform Initialistion') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Terraform Validate and Execution Plan') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"'
                withCredentials([file(credentialsId: 'kubeconfigId', variable: 'KUBECONFIG')]) {
                    sh 'export KUBECONFIG=$KUBECONFIG'
                    sh 'kubectl config use-context sk-k8-cluster'
                    sh 'kubectl apply -f $DEPLOYMENT_FILE'
                    sh 'kubectl rollout restart deployment sk-app-deployment'
                }
            }
        }
    }
}
