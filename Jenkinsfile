pipeline {
  agent {
    docker { image 'maven:3.8.5-openjdk-17' }
  }

  stages {
    stage('Checkstyle') {
      steps {
        checkout scm
        sh 'mvn checkstyle:checkstyle'
      }
      post {
        always {
          archiveArtifacts artifacts: 'target/checkstyle-result.xml', allowEmptyArchive: true
        }
      }
    }
    stage('Test') {
      steps {
        sh 'mvn test -Dcheckstyle.skip=true'
      }
    }
    stage('Build') {
      steps {
        sh 'mvn clean package -DskipTests -Dcheckstyle.skip=true'
      }
      post {
        always {
          archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
        }
      }
    }
    stage('Build Image') {
      agent {
        docker {
          image 'docker:20.10.16'
          args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
      }
      steps {
        checkout scm

        def docker_image=docker.build("mr:8084/spring-petclinic:${GIT_COMMIT}")
        sh 'docker login -u "$REGISTRY_USER" -p "$REGISTRY_PASS" mr:8084'
        
        docker_image.push('${GIT_COMMIT})
        sh 'docker push mr:8084/spring-petclinic:${GIT_COMMIT}'
      }
    }
  }
}
