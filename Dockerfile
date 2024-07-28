# ADF-Workshop Dockerfile
#
# https://www.tosecdev.org/downloads/category/25-ADF-Workshop
#
# NOTES:
#   - We are using WineHQ.
#
# VERSIONS:
# latest - Latest stable version from TOSEC Project Homepage
# beta - Crashdisk beta version

ARG DOCKER_IMAGE_VERSION=1.0.0-3.6.1

# Define software download URLs.
ARG ADFWORKSHOP_URL=https://www.tosecdev.org/downloads/category/25-adf-workshop
ARG ADFWORKSHOP_BASEURL=https://www.tosecdev.org
ARG ADFWORKSHOP_VERSION=stable
ARG ADFWORKSHOP_BETAURL=ftp://ftp@ftp.grandis.nu/Non%20Amiga/Tools%20for%20Amiga/ADF-Workshop/Main%20program/ADF-Workshop_20220402.zip


# Download ADF-Workshop.
FROM alpine:3.17 AS adfw
ARG ADFWORKSHOP_URL
ARG ADFWORKSHOP_BASEURL
ARG ADFWORKSHOP_VERSION
ARG ADFWORKSHOP_BETAURL

RUN \
    apk --no-cache add curl && \
    # Get desired version of ADF-Workshop
    if [ "$ADFWORKSHOP_VERSION" = "beta" ]; then \
        ADFWORKSHOP_DOWNLOAD=${ADFWORKSHOP_BETAURL} && \
        echo "ADFWORKSHOP_DOWNLOAD=" ${ADFWORKSHOP_DOWNLOAD}; \
    elif [ "$ADFWORKSHOP_VERSION" = "stable" ]; then \
        ADFWORKSHOP_DOWNLOAD=$(curl ${ADFWORKSHOP_URL} | \
            sed -n 's/.*href="\([^"]*\).*/\1/p' | \
            grep -i ?download | \
            sort -r -f -u | \
            head -1) \
            && \
            echo "ADFWORKSHOP_DOWNLOAD=" ${ADFWORKSHOP_DOWNLOAD}; \
    else \
        ADFWORKSHOP_DOWNLOAD=$(curl ${ADFWORKSHOP_URL} | \
        sed -n 's/.*href="\([^"]*\).*/\1/p' | \
        grep -i ?download | \
        sort -r -f -u | \
        grep $ADFWORKSHOP_VERSION) \
        && \
        echo "ADFWORKSHOP_DOWNLOAD=" ${ADFWORKSHOP_DOWNLOAD}; \
    fi && \
    # Document, download and extract the desired version of ADF-Workshop
    mkdir -p /defaults/ && \
    if [ "$ADFWORKSHOP_VERSION" = "beta" ]; then \
        echo "adf-workshop" $(basename ${ADFWORKSHOP_DOWNLOAD} .zip | cut -d "_" -f 2) >> /VERSIONS && \
        curl --output /defaults/adf-workshop.zip "${ADFWORKSHOP_BETAURL}" && \
        unzip /defaults/adf-workshop.zip -d /opt/ADF-Workshop/; \
    else \
        echo "adf-workshop" $(basename ${ADFWORKSHOP_DOWNLOAD} .zip | cut -d ":" -f 2) >> /VERSIONS && \
        curl --output /defaults/adf-workshop.zip "${ADFWORKSHOP_BASEURL}/${ADFWORKSHOP_DOWNLOAD}" && \
        unzip /defaults/adf-workshop.zip -d /opt/; \
    fi
    
# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-20.04-v4

RUN \
    LC_ALL=en_US.UTF-8 && LANG=en_US.UTF-8 && LANG=C && \
    APP_ICON_URL=https://cellfi.sh/dat/adf-workshop.png && \
    install_app_icon.sh "$APP_ICON_URL"

RUN \
    set -x && \
    LC_ALL=en_US.UTF-8 && LANG=en_US.UTF-8 && LANG=C && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt install gnupg ca-certificates -y && \
    apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common lsb-release curl -y && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    curl -s https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -c -s) main" && \
    apt-get update && \
    apt-get install -y --no-install-recommends wine wine32 && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    echo Finished

COPY rootfs/ /
COPY --from=adfw /opt/ADF-Workshop/ /opt/ADF-Workshop/
COPY --from=adfw /VERSIONS /VERSIONS
RUN chmod +x /startapp.sh

# Set internal environment variables.
ARG DOCKER_IMAGE_VERSION
RUN \
    export ADFWORKSHOP_VERSION="$(grep adf-workshop /VERSIONS | cut -d'-' -f4-)" && \
    set-cont-env APP_NAME "ADF-Workshop" && \
    set-cont-env APP_VERSION "$ADFWORKSHOP_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    WINDOW_NAME="ADF-Workshop" && \
    set-cont-env WINDOW_NAME "ADF-Workshop ($ADFWORKSHOP_VERSION) \/config" && \
    eval "echo \"$(cat /etc/openbox/main-window-selection.xml)\"" > /etc/openbox/main-window-selection.xml && \
    true

ENV APP_NAME="ADF-Workshop"