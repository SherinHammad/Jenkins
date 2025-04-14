pipeline {
 agent any
    
  stages {
    stage('Terraform Init & Apply') {
      steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')string(credentialsId: 'AWS_SESSION_TOKEN', variable: 'AWS_SESSION_TOKEN')]) {
          sh '''
            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
            export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
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
