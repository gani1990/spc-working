pipeline {
  agent {
    label 'worker5'
  }

  environment {
    imageName = "spring-pet-clinic"

    registryCredentials = "nexus-credentials"
    registry = "https://localhost:9081"
    dockerImage = ''
  }

  tools {
    maven 'm3'
  }

  stages {
    stage ('Docker build') {
      steps {
       script {
          sh 'DOCKER_CERT_PATH=/certs/client DOCKER_TLS_VERIFY=1 DOCKER_HOST=tcp://docker:2376 docker build -t spring-pet-clinic .'

        }
      }

    }
    stage ('Build') {
      steps {
        sh './mvnw -B -DskipTests clean package'
      }
    }

    stage ('Test') { 
      steps {
        sh './mvnw test'
      }
    }

    stage ('Deploy') {
      steps {
        sh 'echo "hello $USER"'
      }
    }

  }
}
