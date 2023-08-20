pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '10', daysToKeepStr: '60'))
    parallelsAlwaysFailFast()
    disableConcurrentBuilds()
  }

    triggers {
      cron(BRANCH_NAME == 'main' ? '59 7 * * 6' : '')
    }

  environment {
    REGISTRY = 'git.devmem.ru'
    REGISTRY_URL = "https://${REGISTRY}"
    REGISTRY_CREDS_ID = 'gitea-user'
    IMAGE_OWNER = 'projects'
    IMAGE_BASENAME = 'python'
    IMAGE_FULLNAME = "${REGISTRY}/${IMAGE_OWNER}/${IMAGE_BASENAME}"
    LABEL_AUTHORS = 'Ilya Pavlov <piv@devmem.ru>'
    LABEL_TITLE = 'Python'
    LABEL_DESCRIPTION = 'Python'
    LABEL_URL = 'https://www.python.org'
    LABEL_CREATED = sh(script: "date '+%Y-%m-%dT%H:%M:%S%:z'", returnStdout: true).toString().trim()
    REVISION = GIT_COMMIT.take(7)
  }

  stages {
    stage('Build') {
      matrix {
        axes {
          axis {
            name 'OS'
            values 'bookworm'
          }
          axis {
            name 'VERSION'
            values '3.11'
          }
          axis {
            name 'TARGET'
            values 'venv-builder', 'playwright-firefox'
          }
        }
        stages {
          stage('Build image (cache)') {
            when {
              branch 'main'
              not {
                anyOf {
                  triggeredBy 'TimerTrigger'
                  triggeredBy cause: 'UserIdCause'
                  changeRequest()
                }
              }
            }
            steps {
              script {
                buildDockerImage(
                  dockerFile: "${TARGET}/Dockerfile",
                  tag: "${VERSION}-${OS}-${TARGET}",
                  buildArgs: ["BUILD_IMAGE=python:${VERSION}-slim-${OS}"],
                  useCache: true
                )
              }
            }
          }
          stage('Build image (no cache)') {
            when {
              branch 'main'
              anyOf {
                triggeredBy 'TimerTrigger'
                triggeredBy cause: 'UserIdCause'
              }
            }
            steps {
              script {
                buildDockerImage(
                  dockerFile: "${TARGET}/Dockerfile",
                  tag: "${VERSION}-${OS}-${TARGET}",
                  buildArgs: ["BUILD_IMAGE=python:${VERSION}-slim-${OS}"]
                )
              }
            }
          }
        }
      }
    }
  }

  post {
    always {
      emailext(
        to: '$DEFAULT_RECIPIENTS',
        subject: '$DEFAULT_SUBJECT',
        body: '$DEFAULT_CONTENT'
      )
    }
  }
}
