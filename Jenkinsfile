pipeline {
  agent {label 'myagent'}
  tools{
       jdk 'Java17'
       maven 'Maven3'
  }

  environment {
        //SONAR_TOKEN = credentials('jenkins-sonarqube-token')  // Reference Jenkins credential
        APP_NAME = "petclinic"
            RELEASE = "1.0.0"
            DOCKER_USER = "gani1990"
            DOCKER_PASS = 'dockerhub'
            IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
            IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"   
	        //JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
    }

stages{
    stage("Cleanup Workspace"){
    steps{
      cleanWs()
          }
      }


 stage("Checkout from SCM"){
      steps{
      git branch: 'main', credentialsId: 'github', url: 'https://github.com/gani1990/spc-working/'
       }
    }

 stage("Build Application"){
      steps{
        sh 'mvn clean package'
      }
    }
stage("Test Application"){
      steps{
       
        sh 'mvn test'
      }
}

  stage("SonarQube Analysis"){
      steps{
        script{
          withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token'){
         sh "mvn sonar:sonar"
          }
      }
    }                         
  }  
  
}
}
