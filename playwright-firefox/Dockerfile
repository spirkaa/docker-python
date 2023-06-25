# hadolint global ignore=DL3006,DL3008,DL3013

ARG BUILD_IMAGE=python:3.11-slim-bullseye

FROM ${BUILD_IMAGE}

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libgtk-3-0 \
        libasound2 \
        libx11-6 \
        libxcomposite1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxrandr2 \
        libxrender1 \
        libxtst6 \
        libfreetype6 \
        libfontconfig1 \
        libpangocairo-1.0-0 \
        libpango-1.0-0 \
        libatk1.0-0 \
        libcairo-gobject2 \
        libcairo2 \
        libgdk-pixbuf-2.0-0 \
        libglib2.0-0 \
        libdbus-glib-1-2 \
        libdbus-1-3 \
        libxcb-shm0 \
        libx11-xcb1 \
        libxcb1 \
        libxcursor1 \
        libxi6 \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip wheel playwright \
    && playwright install firefox
