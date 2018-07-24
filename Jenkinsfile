#!groovy
@Library('github.com/cloudogu/ces-build-lib@68e7f52')
import com.cloudogu.ces.cesbuildlib.*

properties([
        // Don't run concurrent builds, because the ITs use the same port causing random failures on concurrent builds.
        disableConcurrentBuilds()
])

node {

    String cesFqdn = findHostName()
    String cesUrl = "https://${cesFqdn}"
    String credentialsId = 'scmCredentials'

    Maven mvn = new MavenWrapper(this)

    catchError {

        stage('Checkout') {
            checkout scm
        }

        stage('Build') {
            mvn "-DskipTests clean package"

            // archive artifact
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        }

        String jacoco = "org.jacoco:jacoco-maven-plugin:0.8.1"
        parallel(
                test: {
                    stage('Test') {
                        mvn "${jacoco}:prepare-agent test ${jacoco}:report"
                    }
                },
                integrationTest: {
                    stage('Integration Test') {
                        mvn "${jacoco}:prepare-agent-integration failsafe:integration-test ${jacoco}:report-integration"
                    }
                }
        )

        stage('SonarQube Analysis') {

            def sonarQube = new SonarQube(this, [usernamePassword: credentialsId, sonarHostUrl: "${cesUrl}/sonar"])

            sonarQube.analyzeWith(mvn)
        }

        stage('Deploy Artifacts') {
            mvn.setDeploymentRepository(cesFqdn, "${cesUrl}/nexus", credentialsId)

            mvn.deployToNexusRepository('-Dmaven.javadoc.failOnError=false')
        }
    }

    // Archive Unit and integration test results, if any
    junit allowEmptyResults: true, testResults: '**/target/failsafe-reports/TEST-*.xml,**/target/surefire-reports/TEST-*.xml'
}
