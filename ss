pipeline {
    agent any
    stages {
        stage('clone') {
            steps {
                git "https://github.com/devops311/repo3.git"
            }
        }
        stage('Build')
        {
            steps{
                dir("/var/lib/jenkins/workspace/pipelinech/atmosphere/spring-boot-samples/spring-boot-sample-atmosphere")
            {
              sh 'mvn clean compile install'  
            }
            }
        }
    
     stage('Sonar'){
              steps{
                  withSonarQubeEnv('sonarQube'){
                sh "/opt/sonar_scanner/bin/sonar-runner -D sonar.projectKey=environ -D sonar.sources=/var/lib/jenkins/workspace/pipelinech/atmosphere/spring-boot-samples/spring-boot-sample-atmosphere/src"
           } }
        }
         stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
       
        
    }
        
     
            
    stage('Jfrog Artifacory'){
    steps{
        dir("/var/lib/jenkins/workspace/pipelinech/atmosphere/spring-boot-samples/spring-boot-sample-atmosphere"){
    script{
        def server= Artifactory.server 'jenkins-artifactory'
                    def uploadSpec= """{
                        "files": [{
                        "pattern": "target/*.war",
                        "target": "myrepo1"}]
                    }"""
        server.upload(uploadSpec)
    }}
}
}
stage('Creating Image Of Project') {
      steps{
          dir("/var/lib/jenkins/workspace/pipelinech/atmosphere/spring-boot-samples/spring-boot-sample-atmosphere")
          {
        script {
          docker.build registry + ":$BUILD_NUMBER"
        }
      }
      }
    }
    stage('Building image Of Project') {
        steps {
            dir("/var/lib/jenkins/workspace/pipelinech/atmosphere/spring-boot-samples/spring-boot-sample-atmosphere"){
        script {
         dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
        }
    }
    
    
    
    }
    }











# Base Image
FROM openjdk:8

# Create DIR
RUN mkdir -p /usr/src/myapp

# COPY APPLICTAION COde
COPY /Pipeline_challenge-/atmosphere/spring-boot-samples/spring-boot-sample-atmosphere/target/spring-boot-sample-atmosphere-1.4.0.BUILD-SNAPSHOT.jar    /usr/src/myapp

# Setup Working DIR
WORKDIR /usr/src/myapp

#EXPOSE
EXPOSE 8080

# Start the Bot Service
CMD ["java", "-jar", "spring-boot-sample-atmosphere-1.4.0.BUILD-SNAPSHOT.jar"]

~
~
