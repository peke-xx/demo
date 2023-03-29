pipeline {
    agent {
        kubernetes {
            yamlFile './jenkins-agent-pod.yaml'
            workspaceVolume persistentVolumeClaimWorkspaceVolume(claimName: 'jenkins-agent-pvc', readOnly: false)
            envVars: [
                envVar(key: 'GRADLE_USER_HOME', value: '/home/jenkins/agent/')
            ]
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
        stage('init') {
            steps {
                echo 'init stage'
                sh "pwd"
                deleteDir()
            }
            post {
                success {
                    echo 'success init in pipeline'
                }
                failure {
                    error 'fail init in pipeline'
                }
            }
        }
        stage('clone project') {
            steps {
                checkout scm
                sh "pwd"
                sh "ls -al"
            }
            post {
                success {
                    echo 'success clone project'
                }
                failure {
                    error 'fail clone project' // exit pipeline
                }
            }
        }
        stage('build project') {
            steps {
                container('jdk') {
                    sh '''
                    ./gradlew build --no-daemon
                    '''
                    sh "pwd"
                }
            }
            post {
                success {
                    echo 'success build project'
                }
                failure {
                    error 'fail build project' // exit pipeline
                }
            }
        }
        stage('build and push docker image') {
            steps {
                container('kaniko') {
                    sh '''
                    /kaniko/executor --context `pwd` --destination 921784810802.dkr.ecr.us-west-2.amazonaws.com/peke-test:${BUILD_NUMBER}
                    '''
                    sh "pwd"
                }
            }
            post {
                success {
                    echo 'success dockerizing project'
                }
                failure {
                    error 'fail dockerizing project'
                }
            }
        }
    }
}