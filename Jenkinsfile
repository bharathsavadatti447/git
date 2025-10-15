pipeline {
    agent { label 'Node-Linux' }
    environment {
        GIT_REPO = 'https://github.com/bharathsavadatti447/cmake_project.git'
        BRANCH = 'main'
    }
    stages {
        stage('Prepare Tools') {
            steps {
                echo 'Installing required tools...'
                sh '''
                    #!/bin/bash
                    set -e

                    # Update package lists
                    sudo apt update -y

                    # Install Python3, pip3, and venv if missing
                    if ! command -v python3 &>/dev/null || ! command -v pip3 &>/dev/null; then
                        sudo apt install -y python3 python3-pip python3-venv || true
                    fi

                    # Install dos2unix if missing
                    if ! command -v dos2unix &>/dev/null; then
                        sudo apt install -y dos2unix || true
                    fi

                    # Install cmake if missing
                    if ! command -v cmake &>/dev/null; then
                        sudo apt install -y cmake || true
                    fi

                    # Install GCC/G++ compilers if missing
                    if ! command -v gcc &>/dev/null; then
                        sudo apt install -y build-essential || true
                    fi

                    # Create virtual environment if it doesn't exist
                    if [ ! -d "venv" ]; then
                        python3 -m venv venv
                    fi

                    # Activate virtual environment and install cmakelint
                    source venv/bin/activate
                    pip install --quiet cmakelint
                '''
            }
        }
        stage('Lint') {
            steps {
                echo 'Running lint checks on main.c...'
                sh '''
                    #!/bin/bash
                    set -e
                    if [ -f src/main.c ]; then
                        source venv/bin/activate
                        cmakelint src/main.c > lint_report.txt
                    else
                        echo "main.c not found!"
                        exit 1
                    fi
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'lint_report.txt', fingerprint: true
                    fingerprint 'src/main.c'
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Running build.sh...'
                sh '''
                    #!/bin/bash
                    set -e
                    if [ -f build.sh ]; then
                        dos2unix build.sh
                        chmod +x build.sh
                        bash build.sh
                    else
                        echo "build.sh not found!"
                        exit 1
                    fi
                '''
            }
        }
    }
    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Build and lint completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
