FROM ubuntu:jammy

ARG BUILD_DATE
ARG VERSION
ARG CHROME_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ENV TITLE="Chrome"
ENV PORT=3000
ENV CUSTOM_PORT=3000
ARG DEBIAN_FRONTEND="noninteractive"

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
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY /scripts /
COPY /root /
RUN chmod 777 /root

RUN apt-get update && \
  apt-get install -y \
    curl wget ca-certificates gnupg2 \
    fonts-liberation \
    libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 \
    libcups2 libgtk-3-0 libnspr4 libnss3 \
    libu2f-udev libvulkan1 \
    xfce4 xfce4-terminal dbus-x11 \
    python3-numpy procps \
    xvfb x11vnc && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Install Chrome via apt repo (more reliable than direct wget)
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
  apt-get update && \
  (apt-get install -y google-chrome-stable || (sleep 5 && apt-get install -y google-chrome-stable) || (sleep 10 && apt-get install -y google-chrome-stable)) && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

EXPOSE 3000

CMD ["bash", "-c", "vncserver -kill :1 2>/dev/null; USER=root vncserver :1 -geometry 1280x720 -depth 24 && kasmvnchweb --vnc localhost:5901 --listen 0.0.0.0:${PORT} & wait"]
