pipeline {
    environment {
    dockerImage1 = ""
    dockerImage2 = ""
    registryCredential = 'dockerhub'
    registry1='orangius/mysql_m2ssi'
    registry2='orangius/app_m2ssi'
    }

    agent any

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'master', url: 'https://github.com/RichardDufour/app_m2ssi'
            }
        }
        
        stage('Build MySQL Image') {
            steps {
                script {
                    dockerImage1 = docker.build registry1, "-f Dockerfilemysql ."
                }
            }
        }
        
        stage('Build App Image') {
            steps {
                script {
                    dockerImage2 = docker.build registry2, "-f Dockerfilephp ."
                }
            }
        }
        
	    stage('Pushing Image MySQL') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                    dockerImage1.push("latest")
                }
                    
                }
            }
        }
        
        stage('Pushing Image App') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                    dockerImage2.push("latest")
                }
                    
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'sudo kubectl get all'
                }
            }
        }

        // stage('Apply Kubernetes files') {
        //     withKubeConfig([credentialsId: 'user1', serverUrl: 'https://0d2f2d00-4615-4c30-8c61-c94ee188fe34.k8s.ondigitalocean.com']) {
        //     sh 'kubectl cluster-info'
        //     }
        // }
        
        stage('Deploy to Kubernetes with playbook') {
            steps {
                script {
                    sh 'ansible-playbook /deploy_k8s/playbook.yaml'
                    // Ici on peut mettre sh 'kubectl apply -f /deploy_k8s/deployment.yaml' possiblement aussi
                }
            }
        }

    }
}
