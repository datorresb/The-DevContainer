# See here for image contents: https://github.com/devcontainers/images/tree/main/src/python
ARG VARIANT="3.13"
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends ripgrep socat \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir uv \
    && uv --version
USER vscode
