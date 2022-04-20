ARG PYTHON_IMAGE_VERSION=3.10-slim-bullseye

FROM python:${PYTHON_IMAGE_VERSION}

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
        build-essential \
        libpq-dev

RUN set -eux \
    && python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"
