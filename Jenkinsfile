def buildImageCache(String tag, String altTag = null) {
  IMAGE_TAG = "${tag}-bullseye-venv-builder"
  DOCKERFILE = "${tag}/Dockerfile"
  docker.withRegistry("${REGISTRY_URL}", "${REGISTRY_CREDS_ID}") {
    def myImage = docker.build(
      "${IMAGE_FULLNAME}:${IMAGE_TAG}",
      "--label \"org.opencontainers.image.created=${LABEL_CREATED}\" \
      --label \"org.opencontainers.image.authors=${LABEL_AUTHORS}\" \
      --label \"org.opencontainers.image.url=${LABEL_URL}\" \
      --label \"org.opencontainers.image.source=${GIT_URL}\" \
      --label \"org.opencontainers.image.version=${IMAGE_TAG}\" \
      --label \"org.opencontainers.image.revision=${REVISION}\" \
      --label \"org.opencontainers.image.title=${LABEL_TITLE}\" \
      --label \"org.opencontainers.image.description=${LABEL_DESCRIPTION}\" \
      --progress=plain \
      --cache-from ${IMAGE_FULLNAME}:${IMAGE_TAG} \
      -f ${DOCKERFILE} ."
    )
    myImage.push()
    if(altTag) {
      myImage.push(altTag)
    }
    sh "docker rmi -f \$(docker inspect -f '{{ .Id }}' ${myImage.id})"
  }
}

def buildImageNoCache(String tag, String altTag = null) {
  IMAGE_TAG = "${tag}-bullseye-venv-builder"
  DOCKERFILE = "${tag}/Dockerfile"
  docker.withRegistry("${REGISTRY_URL}", "${REGISTRY_CREDS_ID}") {
    def myImage = docker.build(
      "${IMAGE_FULLNAME}:${IMAGE_TAG}",
      "--label \"org.opencontainers.image.created=${LABEL_CREATED}\" \
      --label \"org.opencontainers.image.authors=${LABEL_AUTHORS}\" \
      --label \"org.opencontainers.image.url=${LABEL_URL}\" \
      --label \"org.opencontainers.image.source=${GIT_URL}\" \
      --label \"org.opencontainers.image.version=${IMAGE_TAG}\" \
      --label \"org.opencontainers.image.revision=${REVISION}\" \
      --label \"org.opencontainers.image.title=${LABEL_TITLE}\" \
      --label \"org.opencontainers.image.description=${LABEL_DESCRIPTION}\" \
      --progress=plain \
      --pull \
      --no-cache \
      -f ${DOCKERFILE} ."
    )
    myImage.push()
    if(altTag) {
      myImage.push(altTag)
    }
    sh "docker rmi -f \$(docker inspect -f '{{ .Id }}' ${myImage.id})"
  }
}

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
    IMAGE_OWNER = 'cr'
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
    stage('Set env vars') {
      steps {
        script {
          env.DOCKER_BUILDKIT = 1
        }
      }
    }

    stage('Build 3.10 image') {
      stages {
        stage('Build 3.10 image (cache)') {
          when {
            not {
              anyOf {
                triggeredBy 'TimerTrigger'
                triggeredBy cause: 'UserIdCause'
              }
            }
          }
          steps {
            script {
              buildImageCache '3.10'
            }
          }
        }

        stage('Build 3.10 image (no cache)') {
          when {
            anyOf {
              triggeredBy 'TimerTrigger'
              triggeredBy cause: 'UserIdCause'
            }
          }
          steps {
            script {
              buildImageNoCache '3.10'
            }
          }
        }
      }
    }
  }
}
