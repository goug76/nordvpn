# FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy
FROM ubuntu:22.04
LABEL maintainer="John Goughenrour"
LABEL org.opencontainers.image.source https://github.com/goug76/nordvpn

ARG NORDVPN_VERSION=3.18.1
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y curl iputils-ping libc6 wireguard && \
    curl https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb --output /tmp/nordrepo.deb && \
    apt-get install -y /tmp/nordrepo.deb && \
    apt-get update -y && \
    apt-get install -y nordvpn${NORDVPN_VERSION:+=$NORDVPN_VERSION} && \
    apt-get remove -y nordvpn-release && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf \
		/tmp/* \
		/var/cache/apt/archives/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

COPY /rootfs /

# Ensure /usr/bin is in the PATH
ENV PATH="/usr/bin:${PATH}"

RUN chmod -R +x /usr/bin/
ENV S6_CMD_WAIT_FOR_SERVICES=1
CMD nord_start
