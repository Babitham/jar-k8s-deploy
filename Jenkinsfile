pipeline {
  agent any
  tools {
      maven 'maven'
  }
  stages {
    stage('Maven Install') {
	agent any
      	steps {
		sh 'mvn -B -DskipTests clean compile package'
      	}
    }
    stage('Build-Image') {
      agent any
      steps {
        sh 'docker build -t srirammk18/java-app":$BUILD_NUMBER" .'
      }
    }
	stage ('Push-Image') {
      agent any
      steps {
        withDockerRegistry([ credentialsId: "dockerhub_id", url: "" ]) {
          sh 'docker push srirammk18/java-app":$BUILD_NUMBER"'
        }
      }
	}
  }
}
