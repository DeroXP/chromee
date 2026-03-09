FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CHROME_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="Chrome"
ARG DEBIAN_FRONTEND="noninteractive"

# Railway requires PORT env var and listens on 0.0.0.0
ENV PORT=3000
ENV LISTEN_IP=0.0.0.0

COPY /scripts /

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    fonts-liberation \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libu2f-udev \
    libvulkan1 \
    wget && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

RUN bash /install.sh

# add local files
RUN chmod 777 /root
COPY /root /

# Railway dynamically assigns PORT — expose it
EXPOSE ${PORT}

# Railway doesn't support persistent volumes — use /tmp or /config as ephemeral
VOLUME /config

# Railway needs the app to bind to $PORT on 0.0.0.0
# KasmVNC uses CUSTOM_PORT or LISTEN_IP env vars — set them at runtime
CMD ["bash", "-c", "CUSTOM_PORT=${PORT} /init"]
