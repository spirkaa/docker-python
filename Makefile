.POSIX:

export DOCKER_BUILDKIT=1

TARGETS=venv-builder playwright-firefox

IMAGE_FULLNAME=ghcr.io/spirkaa/python
IMAGE_TAG_PREFIX=3.10-bullseye

default: build

build:
	@for target in ${TARGETS}; do \
		docker build \
			--cache-from ${IMAGE_FULLNAME}:${IMAGE_TAG_PREFIX}-$$target \
			--tag ${IMAGE_FULLNAME}:${IMAGE_TAG_PREFIX}-$$target \
			-f $$target/Dockerfile .; \
	done

build-nocache:
	@for target in ${TARGETS}; do \
		docker build \
			--pull --no-cache \
			--tag ${IMAGE_FULLNAME}:${IMAGE_TAG_PREFIX}-$$target \
			-f $$target/Dockerfile .; \
	done

rmi:
	@for target in ${TARGETS}; do \
		docker rmi ${IMAGE_FULLNAME}:${IMAGE_TAG_PREFIX}-$$target; \
	done

run:
	@docker run \
		--rm \
		--interactive \
		--tty \
		${IMAGE_FULLNAME}:${IMAGE_TAG_PREFIX}-venv-builder
