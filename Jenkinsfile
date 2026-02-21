pipeline {
  agent {
    kubernetes {
      yamlFile 'KubernetesPod.yaml'
    }
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
  }

  environment {
    FAMILY = 'alpine'
    ARCHITECTURE = 'amd64'
  }
  
  stages {

    stage('prepare') {
      steps {
        container('tools') {
          dir('project') {
            echo "preparing the application (FAMILY=${env.FAMILY}, ARCH=${env.ARCHITECTURE})"
            checkout([
              $class: 'GitSCM', 
              branches: [[name: '*/main']], 
              extensions: [[
                $class: 'CloneOption',
                noTags: false,   // <-- key bit: fetch tags
                shallow: false,
                depth: 0,
                timeout: 10
              ]],
              userRemoteConfigs: [[url: 'https://github.com/rsmaxwell/example-c']]
            ])
            sh('./scripts/prepare.sh')
          }
        }
      }
    }

    stage('build') {
      steps {
        container('gcc') {
          dir('project') {
            echo 'building the application'
            sh('./scripts/build.sh')
          }
        }
      }
    }

    stage('test') {
      steps {
        container('alpine') {
          dir('project') {
            echo 'testing the application'
            sh('./scripts/test.sh')
          }
        }
      }
    }

    stage('package') {
      steps {
        container('tools') {
          dir('project') {
            echo 'packaging the application'
            sh('./scripts/package.sh')
          }
        }
      }
    }

    stage('deploy') {
      steps {
        container('maven') {
          dir('project') {
            echo 'deploying the application'
            sh('./scripts/deploy.sh')
          }
        }
      }
    }
  }
}
