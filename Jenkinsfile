pipeline {
  agent any
  tools{
       jdk 'Java17'
       maven 'Maven3'
  }

  environment {
        //SONAR_TOKEN = credentials('jenkins-sonarqube-token')  // Reference Jenkins credential
        APP_NAME = "petclinic-working"
            RELEASE = "1.0.0"
            DOCKER_USER = "gani1990"
            DOCKER_PASS = 'dockerhub'
            IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
            IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"   
	    JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
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

  // stage("SonarQube Analysis"){
  //     steps{
  //       script{
  //         withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token'){
  //        sh "mvn sonar:sonar"
  //         }
  //     }
  //   }                         
  // }  

stage('SonarQube Analysis') {
  steps {
    withSonarQubeEnv('Sonarqube-server') {
      sh '''
        mvn clean verify sonar:sonar
      '''
    }
  }
}
stage("Quality Gate"){
      steps{
        script{
         sleep(10)
          waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'   
      }
    }                         
  } 

stage("Build Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                }
          }
}    

stage("Trivy Scan") {
           steps {
               script {
	            //sh ('trivy image gani1990/petclinic-working:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
                sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image gani1990/petclinic-working:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
               }
           }
}
        
stage("Push Docker Image") {
            steps {
                script {
                     docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        //docker_image.push('latest')
                    }
                  
                }
          }
}  
stage("Trigger CD Pipeline") {
            steps {
                script {
                    sh "curl -v -k --user gani:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'gani:8085/job/spc-working-CD/buildWithParameters?token=gitops-token'"
                }
            }
       }        

  
}
}
