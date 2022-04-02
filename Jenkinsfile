pipeline {
	agent {
		kubernetes {
			yaml '''
			apiVersion: v1
			kind: Pod
			spec:
				containers:
				-	name: ubuntu
					image: ubuntu:20.04
					command:
					- cat
					tty: true
				-	name: maven
					image: maven:alpine
					command:
					- cat
					tty: true
				-	name: c
					image: gcc:latest
					command:
					- cat
					tty: true
			'''
		}
	}
	stages {

		stage('prepare') {
			steps {
				container('ubuntu') {
					echo 'preparing the application'
					checkout([
						$class: 'GitSCM', 
						branches: [[name: '*/main']], 
						extensions: [], 
						userRemoteConfigs: [[url: 'https://github.com/rsmaxwell/example-c']]
					])
				}
				sh('./prepare.sh')
			}
		}

		stage('build') {
			steps {
				container('c') {
					echo 'building the application'
					sh('./build.sh')
				}
			}
		}

		stage('test') {
			steps {
				container('ubuntu') {
					echo 'testing the application'
					sh("./test.sh")
				}
			}
		}

		stage('deploy') {
			steps {
				container('maven') {
					echo 'deploying the application'
					sh('./deploy.sh')
				}
			}
		}
	}
}