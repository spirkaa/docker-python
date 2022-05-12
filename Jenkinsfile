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
        not {
          anyOf {
            triggeredBy 'TimerTrigger'
            triggeredBy cause: 'UserIdCause'
          }
        }
      }
      steps {
        script {
          buildImage(
            dockerFile: "${DOCKERFILE}",
            tag: "${IMAGE_TAG}",
            useCache: true
          )
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
          buildImage(
            dockerFile: "${DOCKERFILE}",
            tag: "${IMAGE_TAG}"
          )
        }
      }
    }
  }
}

def buildImage(Map args) {
  String dockerFile = args.dockerFile
  String tag = args.tag
  String altTag = null
  if(args.altTag) {
    altTag = args.altTag
  }
  boolean useCache = args.useCache

  CACHE = "--pull --no-cache"
  if(useCache) {
    CACHE = "--cache-from ${IMAGE_FULLNAME}:${tag}"
  }
  docker.withRegistry("${REGISTRY_URL}", "${REGISTRY_CREDS_ID}") {
    env.DOCKER_BUILDKIT = 1
    def myImage = docker.build(
      "${IMAGE_FULLNAME}:${tag}",
      "--label \"org.opencontainers.image.created=${LABEL_CREATED}\" \
      --label \"org.opencontainers.image.authors=${LABEL_AUTHORS}\" \
      --label \"org.opencontainers.image.url=${LABEL_URL}\" \
      --label \"org.opencontainers.image.source=${GIT_URL}\" \
      --label \"org.opencontainers.image.version=${tag}\" \
      --label \"org.opencontainers.image.revision=${REVISION}\" \
      --label \"org.opencontainers.image.title=${LABEL_TITLE}\" \
      --label \"org.opencontainers.image.description=${LABEL_DESCRIPTION}\" \
      --progress=plain \
      ${CACHE} \
      -f ${dockerFile} ."
    )
    myImage.push()
    if(altTag) {
      myImage.push(altTag)
    }
    sh "docker rmi -f \$(docker inspect -f '{{ .Id }}' ${myImage.id})"
  }
}
