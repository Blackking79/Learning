def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger'
]

pipeline {
    agent any
    tools {
        maven "MAV3N"
        jdk "JAVA11"
    }
    
    stages {
        stage('Fetching Code') {
            steps {
                git branch: 'main', url: 'https://github.com/devopshydclub/vprofile-project.git'
            }
        }

        stage('Building') {
            steps {
                sh 'mvn install -DskipTests'
            }

            post {
                success {
                    echo 'Archiving Articats is now starting........................'
                    archiveArtifacts artifacts: '**/*.war' 
                }
            }
        }

        stage('Unit Testing') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Checkstyle Testing') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }
        
        stage('SonarQube Analysis') {
            environment {
             scannerHome = tool 'sonar4.7'
            }

            steps {
                withSonarQubeEnv('sonar') {
                sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile-repo \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                }   
            }
        }

        stage('QualityGate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                
                waitForQualityGate abortPipeline: true
                
                }
            }    
        }

        stage('Uploading to Nexus') {
            steps {
                nexusArtifactUploader(
                nexusVersion: 'nexus3',
                protocol: 'http',
                nexusUrl: '192.168.60.11:8081',
                groupId: 'QA',
                version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}}",
                repository: 'vprofile-repo',
                credentialsId: 'NexusLogin',
                artifacts: [
                    [artifactId: 'vproapp',
                    classifier: '',
                    file: 'target/vprofile-v2.war',
                    type: 'war']
                ]
                )
            }
            post {
                always {
                    echo 'Sending Slack Notification......'
                    slackSend channel: '#devops',
                    color: COLOR_MAP[currentBuild.currentResult],
                    message: "Build Number ${env.BUILD_ID} has been successfully deployed to Nexus Repository \n *${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
                }
            }
        }
        
    }
}