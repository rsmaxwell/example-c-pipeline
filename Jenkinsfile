pipeline {
  agent {
    kubernetes {
      yaml '''
      apiVersion: "v1"
      kind: "Pod"
      metadata:
        annotations:
          buildUrl: "http://tintin:8080/job/example-c-pipeline/job/main/13/"
          runUrl: "job/example-c-pipeline/job/main/13/"
        labels:
          jenkins: "slave"
          jenkins/label-digest: "48a2ae816290614619175dc7517284d3d3fd1897"
          jenkins/label: "example-c-pipeline_main_13-5qsdm"
        name: "example-c-pipeline-main-13-5qsdm-2n7dh-f735m"
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
          - name: "JENKINS_SECRET"
            value: "********"
          - name: "JENKINS_AGENT_NAME"
            value: "example-c-pipeline-main-13-5qsdm-2n7dh-f735m"
          - name: "JENKINS_WEB_SOCKET"
            value: "true"
          - name: "JENKINS_NAME"
            value: "example-c-pipeline-main-13-5qsdm-2n7dh-f735m"
          - name: "JENKINS_AGENT_WORKDIR"
            value: "/home/jenkins/agent"
          - name: "JENKINS_URL"
            value: "http://tintin:8080/"
          image: "jenkins/inbound-agent:4.11-1-jdk11"
          name: "jnlp"
          resources:
            limits: {}
            requests:
              memory: "256Mi"
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