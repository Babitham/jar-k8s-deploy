pipeline {
  environment {
  IBM_CLOUD_REGION = 'eu-de'
  REGISTRY_HOSTNAME = 'de.icr.io'
  IKS_CLUSTER = 'c0sf25ud0fesivtjm07g'
  DEPLOYMENT_NAME = 'iks-jar'
  PORT = '5002'
  registry = "babitham/jar-k8s"
  registryCredential = 'dockerhub_id'
  dockerImage = ''
  }
  agent any 
  tools {
      maven 'maven'
  }
  stages { 
    stage('Maven Build') {
	    steps {
				bat 'mvn -B -DskipTests clean compile package'
			}
		}
		stage('Test') {
			steps {
				bat 'mvn test'
			}
		}   
    stage('Install IBM Cloud CLI') {
      steps { 
        bat ''' 
            curl -fsSL https://clis.cloud.ibm.com/install/linux | bat
            ibmcloud --version
            ibmcloud config --check-version=false
            ibmcloud plugin install -f kubernetes-service
            ibmcloud plugin install -f container-registry
            '''
      }
    }
    stage('Authenticate with IBM Cloud CLI') {
      steps {
        bat '''
            ibmcloud login --apikey ${IBM_API_KEY} -r "${IBM_CLOUD_REGION}" -g Default
            ibmcloud ks cluster config --cluster ${IKS_CLUSTER}
            '''
      }
    }
    stage('Build with Docker') {
      steps {
        script {
        dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push the image to ICR') {
      steps {
        script {
          docker.withRegistry( '', registryCredential ) {
          dockerImage.push()
          }
        }
      }
    }
    stage('Deploy to IKS') {
      steps {
        bat '''
            ibmcloud ks cluster config --cluster ${IKS_CLUSTER}
            kubectl config current-context
            kubectl create deployment ${DEPLOYMENT_NAME} --image=srirammk18/jar-k8s:$BUILD_NUMBER --dry-run -o yaml > deployment.yaml
            kubectl apply -f deployment.yaml
            kubectl rollout status deployment/${DEPLOYMENT_NAME}
            kubectl create service loadbalancer ${DEPLOYMENT_NAME} --tcp=80:${PORT} --dry-run -o yaml > service.yaml
            kubectl apply -f service.yaml
            kubectl get services -o wide
            '''
      }
    }
  }
}
