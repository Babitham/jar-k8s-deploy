pipeline {
  agent any
  tools {
      maven 'maven'
  }
  stages {
    stage('Maven Build') {
      	steps {
		sh 'mvn -B -DskipTests clean compile package'
      	}
    }
    stage('Test') {
       steps {
	    sh 'mvn test'
	  }
    }
    stage('Build-Image') {
      steps {
        sh 'docker build -t srirammk18/java-app":$BUILD_NUMBER" .'
      }
    }
      stage ('Push-Image') {
        steps {
        withDockerRegistry([ credentialsId: "dockerhub_id", url: "" ]) {
          sh 'docker push srirammk18/java-app":$BUILD_NUMBER"'
        }
      }
    }
  }
}
