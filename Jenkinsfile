pipeline {
    agent any

    environment {
        TF_VAR_aws_access_key = credentials('aws-access-key')  // Jenkins credentials
        TF_VAR_aws_secret_key = credentials('aws-secret-key')
    }

    stages {

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'          //  Skip the interactive "yes/no" prompt
            }
        }

        stage('Wait for EC2 Readiness') {
            steps {
                echo 'Waiting 60 seconds for EC2 instance to boot...'
                sleep time: 120, unit: 'SECONDS'
            }
        }

        stage('Get EC2 Public IP') {
            steps {
                script {
                    def ip = sh(script: "terraform output -raw public_ip", returnStdout: true).trim()
                    writeFile file: 'inventory.ini', text: "[ec2]\n${ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/my-key.pem"
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sh 'ansible-playbook -i inventory.ini playbook.yml'
            }
        }
    }

    
}
