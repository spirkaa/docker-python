.POSIX:

export DOCKER_BUILDKIT=1

PYTHON_VERSION=3.10

IMAGE_FULLNAME=git.devmem.ru/cr/python
IMAGE_TAG=${PYTHON_VERSION}-bullseye-venv-builder
IMAGE=${IMAGE_FULLNAME}:${IMAGE_TAG}

default: build

build:
	@docker build \
		--cache-from ${IMAGE} \
		--tag ${IMAGE} \
		-f ${PYTHON_VERSION}/Dockerfile .

build-nocache:
	@docker build \
		--pull --no-cache \
		--tag ${IMAGE} \
		-f ${PYTHON_VERSION}/Dockerfile .

rmi:
	@docker rmi ${IMAGE}

run:
	@docker run \
		--rm \
		--interactive \
		--tty \
		${IMAGE}
