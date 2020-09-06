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
                           sh "composer install --prefer-dist --optimize-autoloader --no-dev"
                           sh "composer update"
                        }
                        failure{
                            echo "Failed"
                        }
                    }
                }
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