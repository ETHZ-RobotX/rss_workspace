# syntax=docker/dockerfile:1

ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    x11-apps \
    x11-utils \
    mesa-utils \
    gnome-terminal \
    && rm -rf /var/lib/apt/lists/*

ARG VNC_RESOLUTION
ENV VNC_RESOLUTION=$VNC_RESOLUTION

