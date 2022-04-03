pipeline {
  agent {
    kubernetes {
      yaml '''
      apiVersion: "v1"
      kind: "Pod"
      spec:
        containers:
        - command:
          - "cat"
          image: "ubuntu:20.04"
          name: "ubuntu"
          tty: true
          volumeMounts:
          - mountPath: "/home/jenkins/agent"
            name: "workspace-volume"
            readOnly: false
        - command:
          - "cat"
          image: "maven:alpine"
          name: "maven"
          tty: true
          volumeMounts:
          - mountPath: "/home/jenkins/agent"
            name: "workspace-volume"
            readOnly: false
        - command:
          - "cat"
          image: "gcc:latest"
          name: "c"
          tty: true
          volumeMounts:
          - mountPath: "/home/jenkins/agent"
            name: "workspace-volume"
            readOnly: false
        - env:
          resources:
            requests:
              memory: "2Gi"
              cpu: "100m"
          volumeMounts:
          - mountPath: "/home/jenkins/agent"
            name: "workspace-volume"
            readOnly: false
        nodeSelector:
          kubernetes.io/os: "linux"
        restartPolicy: "Never"
        volumes:
        - emptyDir:
            medium: ""
          name: "workspace-volume"
      '''
    }
  }
  stages {

    stage('prepare') {
      steps {
        container('ubuntu') {
          echo 'preparing the application'
          dir('src') {
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
        sh('ls -al src')
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