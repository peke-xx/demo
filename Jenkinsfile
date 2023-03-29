pipeline {
    agent {
        kubernetes {
            yamlFile './jenkins-agent-pod.yaml'
        }
    }
    environment {
        REPOSITORY_CREDENTIAL_ID = 'github-token'
        REPOSITORY_URL = 'https://github.com/peke-xx/demo.git'
        TARGET_BRANCH = 'master'

        ECR_PATH = '921784810802.dkr.ecr.us-west-2.amazonaws.com'
        IMAGE_NAME = '921784810802.dkr.ecr.us-west-2.amazonaws.com/peke-test'
        AWS_REGION = 'eu-west-2'
        AWS_CREDENTIALS_NAME = 'aws-credentials'
    }
    stages{
        stage('clone project') {
            checkout scm
            sh "ls -al"
        }
        stage('build project') {
            container('jdk') {
                sh '''
                ./gradlew build --no-daemon
                '''
            }
        }
        stage('build and push docker image') {
            container('kaniko') {
                sh '''
                /kaniko/executor --context `pwd` --destination 921784810802.dkr.ecr.us-west-2.amazonaws.com/peke-test:${BUILD_NUMBER}
                '''
            }
        }
    }
}