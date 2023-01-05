ARG BUILD_IMAGE=python:3.10-slim-bullseye

FROM ${BUILD_IMAGE}

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libldap2-dev \
        libsasl2-dev \
        libpq-dev \
        libssl-dev \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux \
    && python -m venv /opt/venv \
    && PATH="/opt/venv/bin:$PATH" \
    && pip install --no-cache-dir --upgrade pip wheel

ENV PATH="/opt/venv/bin:$PATH"
