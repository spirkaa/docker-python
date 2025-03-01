# hadolint global ignore=DL3006,DL3008,DL3013

ARG BUILD_IMAGE=python:3.13-slim-bookworm

FROM ${BUILD_IMAGE}

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        git \
        libldap2-dev \
        libsasl2-dev \
        libpq-dev \
        libssl-dev \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv \
    && PATH="/opt/venv/bin:$PATH" \
    && pip install --no-cache-dir --upgrade pip wheel

ENV PATH="/opt/venv/bin:$PATH"
