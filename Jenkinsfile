pipeline {
  agent {
    kubernetes {
      yaml '''
      apiVersion: v1
      kind: Pod
      spec:
        containers:
        - name: tools
          image: rsmaxwell/tools:latest
          command:
          - cat
          tty: true
        - name: c
          image: gcc:latest
          command:
          - cat
          tty: true
        - name: maven
          image: maven:alpine
          command:
          - cat
          tty: true
        resources:
          requests:
            memory: "2Gi"
            cpu: "100m"
      '''
    }
  }
  stages {

    stage('prepare') {
      steps {
        container('tools') {
          echo 'preparing the application'
          dir('project') {
            checkout([
              $class: 'GitSCM', 
              branches: [[name: '*/main']], 
              extensions: [], 
              userRemoteConfigs: [[url: 'https://github.com/rsmaxwell/example-c']]
            ])
          }
        }
        sh('pwd')
        sh('ls -al')
        sh('ls -al project')
        sh('./project/scripts/prepare.sh')
      }
    }

    stage('build') {
      steps {
        container('c') {
          echo 'building the application'
          sh('./project/scripts/build.sh')
        }
      }
    }

    stage('test') {
      steps {
        container('tools') {
          echo 'testing the application'
          sh('./project/scripts/test.sh')
        }
      }
    }

    stage('package') {
      steps {
        container('tools') {
          echo 'packaging the application'
          sh('./project/scripts/package.sh')
        }
      }
    }

    stage('deploy') {
      steps {
        container('maven') {
          echo 'deploying the application'
          sh('./project/scripts/deploy.sh')
        }
      }
    }
  }
}
