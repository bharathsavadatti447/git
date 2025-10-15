pipeline {
    agent { label 'Node-Linux' }
    environment {
        GIT_REPO = 'https://github.com/bharathsavadatti447/cmake_project.git'
        BRANCH = 'main'
        VENV_DIR = 'venv' // virtual environment directory
    }
    stages {
        stage('Prepare Tools') {
            steps {
                echo 'Installing required tools...'
                sh '''
                    # Update and install Python3, pip, venv if missing
                    sudo apt update -y
                    sudo apt install -y python3 python3-venv python3-pip dos2unix cmake build-essential || true

                    # Create virtual environment if not exists
                    if [ ! -d ${VENV_DIR} ]; then
                        python3 -m venv ${VENV_DIR}
                    fi

                    # Upgrade pip and install cmakelint in venv
                    ${VENV_DIR}/bin/pip install --upgrade pip
                    ${VENV_DIR}/bin/pip install cmakelint
                '''
            }
        }

        stage('Checkout') {
            steps {
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Lint') {
            steps {
                echo 'Running lint checks on src/main.c...'
                sh '''
                    # Run cmakelint using virtual environment directly
                    if [ -f src/main.c ]; then
                        ${VENV_DIR}/bin/cmakelint src/main.c > lint_report.txt
                        # Uncomment to fail build if errors
                        # grep -q "Total Errors: [1-9]" lint_report.txt && exit 1 || true
                    else
                        echo "src/main.c not found!"
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
