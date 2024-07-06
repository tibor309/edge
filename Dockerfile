FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set labels
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL maintainer="tibor309"
LABEL org.opencontainers.image.description="Web accessible microsoft edge browser."
LABEL org.opencontainers.image.source=https://github.com/tibor309/edge
LABEL org.opencontainers.image.url=https://github.com/tibor309/edge/packages
LABEL org.opencontainers.image.licenses=GPL-3.0

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config"
ENV TITLE="Microsoft Edge"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/tibor309/icons/main/icons/msedge/msedge-stable_logo_256x256.png && \
  curl -o \
    /kclient/public/favicon.ico \
    https://raw.githubusercontent.com/tibor309/icons/main/icons/msedge/msedge-stable_icon_32x32.ico && \
  echo "**** install packages ****" && \
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
  install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
  sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list' && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    microsoft-edge-stable && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    ./microsoft.gpg \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
