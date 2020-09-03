pipeline {
        environment {
            registry = "gits5622/test"
            registryCredential = 'docker-hub'
            dockerImage = ''
            }
        agent any
        stages {
                stage('Cloning our Git') {
                    steps {
                    git 'https://github.com/gitx5622/test.git'
                    }
                }
                stage('Building our image') {
                    steps{
                        script {
                        dockerImage = docker.build registry
                        }
                    }
                    post{
                        always{
                            echo "Running"
                        }
                        success{

                           echo "Build Success"
                        }
                        failure{
                            echo "Failed"
                        }
                    }
                }
//                 stage ('Composer install'){
//                     steps{
//                        sh "composer install --prefer-dist --optimize-autoloader --no-dev"
//                        sh "composer update"
// //                        sh "chmod -R 777 runtime web/assets"
//                     }
//                 }

                stage('Deploy our image') {
                    steps{
                        script {
                        docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                            }
                        }
                    }
                }
                stage ('Running tha Application'){
                    steps{
                        sh "docker-compose up -d"
                    }
                }


    }
}