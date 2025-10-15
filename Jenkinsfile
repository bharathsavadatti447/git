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
                    # Update package lists
                    sudo apt update -y

                    # Install Python3 and pip3 if missing
                    if ! command -v pip3 &>/dev/null; then
                        sudo apt install -y python3 python3-pip || true
                    fi

                    # Install cmakelint
                    pip3 install --quiet cmakelint

                    # Install dos2unix if missing
                    if ! command -v dos2unix &>/dev/null; then
                        sudo apt install -y dos2unix || true
                    fi

                    # Install cmake if missing
                    if ! command -v cmake &>/dev/null; then
                        sudo apt install -y cmake || true
                    fi

                    # Install GCC/G++ compilers for C/C++ build if missing
                    if ! command -v gcc &>/dev/null; then
                        sudo apt install -y build-essential || true
                    fi
                '''
            }
        }
        stage('Lint') {
            steps {
                echo 'Running lint checks on main.c...'
                sh '''
                    if [ -f src/main.c ]; then
                        cmakelint src/main.c > lint_report.txt
                        # Fail build if lint errors found (uncomment if strict)
                        # grep -q "Total Errors: [1-9]" lint_report.txt && exit 1 || true
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
