# syntax=docker/dockerfile:1

###########################################################################
########### This is the devcontainer base image for SuperMegaBot(SMB)    ##
########### It is built and pushed to Github Container Registry by CI    ##
###########################################################################

ARG SMB_REPO_FULL_NAME=ETHZ-RobotX/SuperMegaBot
ARG SMB_REPO_BRANCH_NAME=docker
ARG SMB_RAW_REPO_URL=https://raw.githubusercontent.com/${SMB_REPO_FULL_NAME}/${SMB_REPO_BRANCH_NAME}
ARG SMB_RAW_REPO_FILE_URL=${SMB_RAW_REPO_URL}/smb.repos

ARG BASE_IMAGE=ghcr.io/ethz-robotx/smb_ros_base:latest
ARG OVERLAY_WS=/smb_ws

# Cache package.xml and python requirements.txt
FROM $BASE_IMAGE AS cacher

ARG OVERLAY_WS
ARG SMB_REPO_BRANCH_NAME
ARG SMB_RAW_REPO_URL

# Fetch source code
WORKDIR ${OVERLAY_WS}/src
RUN vcs import --recursive --input ${SMB_RAW_REPO_FILE_URL}

WORKDIR /tmp
RUN find ${OVERLAY_WS}/src -name "package.xml" | \
    xargs cp --parents -t /tmp && \
    find ${OVERLAY_WS}/src -name "requirements.txt" | \
    xargs cp --parents -t /tmp || true && \
    find ${OVERLAY_WS}/src -name "CATKIN_IGNORE" | \
    xargs cp --parents -t /tmp || true

FROM $BASE_IMAGE AS default

ARG DEBIAN_FRONTEND=noninteractive

# Nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Install SMB dependencies
# Most of the dependencies are installed in the base image
# This is only for the dependencies that added after the base image is built
ARG OVERLAY_WS
RUN --mount=type=bind,from=cacher,source=/tmp/${OVERLAY_WS}/src,target=${OVERLAY_WS}/src \
    rosdep update && \
    apt-get update && \
    rosdep install --from-paths ${OVERLAY_WS}/src --ignore-src --os=ubuntu:focal -r -y && \
    rm -rf /var/lib/apt/lists/*

# Save SMB_RAW_REPO_FILE_URL as an environment variable
# It is used to fetch source code in post-create.sh script of devcontainer
ENV SMB_RAW_REPO_FILE_URL=${SMB_RAW_REPO_FILE_URL}

