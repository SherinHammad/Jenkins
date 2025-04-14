pipeline {
  agent any

  stages {
    stage('Terraform Init & Apply') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY'),
          string(credentialsId: 'AWS_SESSION_TOKEN', variable: 'AWS_SESSION_TOKEN')
        ]) {
          sh '''
            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
            export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN

            terraform init
            terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Wait for EC2 Readiness') {
      steps {
        echo 'Waiting 120 seconds for EC2 instance to boot...'
        sleep time: 120, unit: 'SECONDS'
      }
    }

    stage('Extract & Write Private Key') {
      steps {
        script {
          def privateKey = sh(script: "terraform output -raw private_key_pem", returnStdout: true).trim()
          def keyPath = "/tmp/my-key.pem"
          writeFile file: keyPath, text: privateKey
          sh "chmod 600 ${keyPath}"
          env.KEY_PATH = keyPath
        }
      }
    }

    stage('Get EC2 Public IP & Create Inventory') {
      steps {
        script {
          def ip = sh(script: "terraform output -raw public_ip", returnStdout: true).trim()
          def inventoryPath = "/tmp/inventory.ini"
          writeFile file: inventoryPath, text: "[ec2]\n${ip} ansible_user=ubuntu ansible_ssh_private_key_file=${env.KEY_PATH}"
          env.INVENTORY_PATH = inventoryPath
        }
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sh "ansible-playbook -i ${env.INVENTORY_PATH} playbook.yaml"
      }
    }
  }
}
