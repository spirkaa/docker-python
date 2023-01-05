.POSIX:

export DOCKER_BUILDKIT=1

OS=bullseye
VERSIONS=3.10 3.11
TARGETS=venv-builder playwright-firefox

IMAGE_FULLNAME=ghcr.io/spirkaa/python

default: build

build:
	@for version in ${VERSIONS}; do \
		for target in ${TARGETS}; do \
			docker build \
				--cache-from ${IMAGE_FULLNAME}:$${version}-${OS}-$${target} \
				--tag ${IMAGE_FULLNAME}:$${version}-${OS}-$${target} \
				--build-arg BUILD_IMAGE=python:$${version}-slim-${OS} \
				-f $${target}/Dockerfile .; \
		done \
	done

build-nocache:
	@for version in ${VERSIONS}; do \
		for target in ${TARGETS}; do \
			docker build \
				--pull --no-cache \
				--tag ${IMAGE_FULLNAME}:$${version}-${OS}-$${target} \
				--build-arg BUILD_IMAGE=python:$${version}-slim-${OS} \
				-f $${target}/Dockerfile .; \
		done \
	done

rmi:
	@for version in ${VERSIONS}; do \
		for target in ${TARGETS}; do \
			docker rmi ${IMAGE_FULLNAME}:$${version}-${OS}-$${target} || true; \
		done \
	done

run:
	@docker run \
		--rm \
		--interactive \
		--tty \
		${IMAGE_FULLNAME}:3.11-${OS}-venv-builder
