pipeline {
    agent any
    stages {
        stage('Run Script') {
            steps {
                sh 'chmod +x factorial_for_given_number.sh'
                sh './factorial_for_given_number.sh'
            }
        }
        stage('clone') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/bharathsavadatti447/git.git'
            }
        }
    }
}
