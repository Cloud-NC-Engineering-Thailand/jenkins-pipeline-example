pipeline {
  agent any
  environment {
        APP_NAME = "helloworld-app"
        RELEASE = "1.0.0"
        DOCKER_USER = credentials('DOCKER_USER')
        DOCKER_PASS = credentials('DOCKER_PASS')
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        /* JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN") */

    }

  stages {

    stage("Cleanup Workspace") {
      steps {
        cleanWs()
      }
    }

    stage("Checkout from SCM"){
            steps {
                git branch: 'master', credentialsId: '6c4333a6-a956-4d65-8923-3b48fb5e4d4a', url: 'https://github.com/netchanokmu/test-kaniko-build.git'
            }
        }


    stage('Build & Push with Kaniko') {
      agent {
        kubernetes {
            yamlFile 'kaniko-builder.yaml'
        }
      }
      steps {
        container(name: 'kaniko', shell: '/busybox/sh') {
          sh '''#!/busybox/sh

            /kaniko/executor --dockerfile `pwd`/Dockerfile --context `pwd` --destination=${IMAGE_NAME}:${IMAGE_TAG} --destination=${IMAGE_NAME}:latest
          '''
        }
      }
    }

    stage('Deploy with Kubernetes') {
      agent {
        kubernetes {
            yamlFile 'kubectl-agent.yaml'
        }
      }
      steps {
        container(name: 'kubectl', shell: '/bin/sh') {
          sh '''#!/bin/sh
            kubectl apply -f deployment.yaml
          '''
        }
      }
    }
}
}
