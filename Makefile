.POSIX:

export DOCKER_BUILDKIT=1

TAG=git.devmem.ru/cr/python
PYTHON_VERSION=3.10

default: build

build:
	@docker build --tag ${TAG}:${PYTHON_VERSION}-bullseye-venv-builder -f ${PYTHON_VERSION}/Dockerfile .
