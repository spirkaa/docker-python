pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '10', daysToKeepStr: '60'))
    parallelsAlwaysFailFast()
    disableConcurrentBuilds()
  }

    triggers {
      cron('H 5 * * 6')
    }

  environment {
    REGISTRY = 'git.devmem.ru'
    REGISTRY_URL = "https://${REGISTRY}"
    REGISTRY_CREDS_ID = 'gitea-user'
    IMAGE_OWNER = 'projects'
    IMAGE_BASENAME = 'python'
    IMAGE_FULLNAME = "${REGISTRY}/${IMAGE_OWNER}/${IMAGE_BASENAME}"
    IMAGE_TAG = '3.10-bullseye-venv-builder'
    DOCKERFILE = '3.10/Dockerfile'
    LABEL_AUTHORS = 'Ilya Pavlov <piv@devmem.ru>'
    LABEL_TITLE = 'Python'
    LABEL_DESCRIPTION = 'Python'
    LABEL_URL = 'https://www.python.org'
    LABEL_CREATED = sh(script: "date '+%Y-%m-%dT%H:%M:%S%:z'", returnStdout: true).toString().trim()
    REVISION = GIT_COMMIT.take(7)
  }

  stages {
    stage('Build 3.10 image (cache)') {
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
            dockerFile: "${DOCKERFILE}",
            tag: "${IMAGE_TAG}",
            useCache: true
          )
        }
      }
    }

    stage('Build 3.10 image (no cache)') {
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
            dockerFile: "${DOCKERFILE}",
            tag: "${IMAGE_TAG}"
          )
        }
      }
    }
  }
}
