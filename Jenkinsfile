pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/bharathsavadatti447/git.git'
            }
        }

        stage('Run factorial script') {
            steps {
                sh 'chmod +x factorial_for_given_number.sh'
                sh './factorial_for_given_number.sh'
            }
        }

        stage('Run random script') {
            steps {
                sh 'chmod +x random.sh'
                sh './random.sh'
            }
        }
    }
}
