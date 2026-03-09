FROM ubuntu:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CHROME_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ENV TITLE="Chrome"
ENV PORT=3000
ENV CUSTOM_PORT=3000
ARG DEBIAN_FRONTEND="noninteractive"

# Install KasmVNC + dependencies manually (replaces the base image)
RUN apt-get update && \
  apt-get install -y \
    curl wget ca-certificates gnupg2 \
    fonts-liberation \
    libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 \
    libcups2 libgtk-3-0 libnspr4 libnss3 \
    libu2f-udev libvulkan1 \
    xfce4 xfce4-terminal dbus-x11 \
    python3-numpy \
    procps && \
  # Install KasmVNC
  ARCH=$(dpkg --print-architecture) && \
  wget -q "https://github.com/kasmtech/KasmVNC/releases/download/v1.3.0/kasmvncserver_jammy_1.3.0_${ARCH}.deb" -O /tmp/kasmvnc.deb && \
  apt-get install -y /tmp/kasmvnc.deb && \
  rm /tmp/kasmvnc.deb && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb && \
  apt-get install -y /tmp/chrome.deb && \
  rm /tmp/chrome.deb && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY /root /

RUN chmod 777 /root

EXPOSE 3000

CMD ["bash", "-c", "kasmvncserver -select-de xfce -passwd password -noxstartup & sleep 2 && CUSTOM_PORT=${PORT} /usr/share/kasmvnc/www/kasmvnc_defaults.sh; tail -f /dev/null"]
