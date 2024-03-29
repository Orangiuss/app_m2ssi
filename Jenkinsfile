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

        stage('Deploy to Kubernetes Secrets') {
            steps {
                script {
                    sh 'sudo kubectl apply -f ./deploy/secrets.yaml'
                }
            }
        }

        stage('Deploy to Kubernetes Volumes') {
            steps {
                script {
                    sh 'sudo kubectl apply -f ./deploy/volumes_mysql.yaml'
                }
            }
        }

        stage('Deploy to Kubernetes MySQL') {
            steps {
                script {
                    sh 'sudo kubectl apply -f ./deploy/mysql_deploy.yaml'
                }
            }
        }

        stage('Deploy to Kubernetes App') {
            steps {
                script {
                    sh 'sudo kubectl apply -f ./deploy/app_deploy.yaml'
                }
            }
        }

        stage('Update deployments of app and mysql') {
            steps {
                script {
                    sh 'sudo kubectl rollout status deployment/mysql'
                    sh 'sudo kubectl rollout status deployment/app-deployment'
                }
            }
        }

        // Ici on peut mettre un sleep pour attendre que les pods soient prêts
        stage('Wait for pods') {
            steps {
                script {
                    sh 'sudo sleep 30'
                }
            }
        }

        stage('Rollout app') {
            steps {
                script {
                    sh 'sudo kubectl set image deployment/app-deployment nginx=orangius/app_m2ssi:latest'
                    sh 'sudo kubectl set image deployment/app-deployment nginx=orangius/app_m2ssi'
                }
            }
        }

        stage('Rollout mysql') {
            steps {
                script {
                    sh 'sudo kubectl set image deployment/mysql mysql=orangius/mysql_m2ssi:latest'
                    sh 'sudo kubectl set image deployment/mysql mysql=orangius/mysql_m2ssi'
                }
            }
        }


        // stage('Apply Kubernetes files') {
        //     withKubeConfig([credentialsId: 'user1', serverUrl: 'https://0d2f2d00-4615-4c30-8c61-c94ee188fe34.k8s.ondigitalocean.com']) {
        //     sh 'kubectl cluster-info'
        //     }
        // }
        
        // stage('Deploy to Kubernetes with playbook') {
        //     steps {
        //         script {
        //             sh 'ansible-playbook /deploy_k8s/playbook.yaml'
        //             // Ici on peut mettre sh 'kubectl apply -f /deploy_k8s/deployment.yaml' possiblement aussi
        //         }
        //     }
        // }

    }
}
