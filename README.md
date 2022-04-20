# Docker: Python

Образы Python:

* Debian на основе [python](https://hub.docker.com/_/python) с build-essential, libpq-dev как база для multistage сборок
* Alpine на основе докерфайлов [jfloff/alpine-python](https://github.com/jfloff/alpine-python) с пакетами lxml, brotli, psycopg2

## Тэги

    git.devmem.ru/cr/python:3.10-bullseye-venv-builder
    registry.home.devmem.ru/python:3.9-alpine
