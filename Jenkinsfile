pipeline {
    agent {
        kubernetes {
            yamlFile './jenkins-agent-pod.yaml'
            workspaceVolume persistentVolumeClaimWorkspaceVolume(claimName: 'jenkins-agent-pvc', readOnly: false)
            defaultContainer 'jnlp'
        }
    }
    environment {
        IMAGE_NAME = '921784810802.dkr.ecr.us-west-2.amazonaws.com/peke-test'
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
                sh '''
                ./gradlew build --no-daemon
                '''
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
                    /kaniko/executor --context `pwd` --destination ${IMAGE_NAME}:${BUILD_NUMBER}
                    '''
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