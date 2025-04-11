FROM debian:latest AS base
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
    && apt install --no-install-recommends -y ca-certificates wget x11-xkb-utils xkbset curl unzip locales locales-all fonts-nanum fonts-noto-cjk fonts-noto-cjk-extra fonts-dejavu fonts-liberation fonts-noto fonts-unfonts-core fonts-unfonts-extra \
    && locale-gen zh_CN.UTF-8 \
    && update-locale LANG=zh_CN.UTF-8 \
    && rm -rf /var/lib/apt/lists/* \
    && echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

FROM base AS desktop
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive \
    # thunar 
    && apt install --no-install-recommends -y pcmanfm tint2 openbox xauth xinit \
    && rm -rf /var/lib/apt/lists/*

FROM desktop AS tigervnc
RUN wget --no-check-certificate -qO- https://sourceforge.net/projects/tigervnc/files/stable/1.15.0/tigervnc-1.15.0.x86_64.tar.gz | tar xz --strip 1 -C /


FROM tigervnc AS novnc
ENV NO_VNC_HOME=/usr/share/usr/local/share/noVNCdim
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y python3-numpy libasound2 libxshmfence1 libxcvt0 libgbm1 \
    && mkdir -p "${NO_VNC_HOME}/utils/websockify" \
    && wget --no-check-certificate -qO- "https://github.com/novnc/noVNC/archive/v1.6.0.tar.gz" | tar xz --strip 1 -C "${NO_VNC_HOME}" \
    && wget --no-check-certificate -qO- "https://github.com/novnc/websockify/archive/v0.13.0.tar.gz" | tar xz --strip 1 -C "${NO_VNC_HOME}/utils/websockify" \
    && chmod +x -v "${NO_VNC_HOME}/utils/novnc_proxy" \
    && sed -i '1s/^/if(localStorage.getItem("resize") == null){localStorage.setItem("resize","remote");}\n/' "${NO_VNC_HOME}/app/ui.js" \
    && rm -rf /var/lib/apt/lists/*

FROM novnc AS baidunetdisk
ENV \
    XDG_CONFIG_HOME=/opt \
    XDG_CACHE_HOME=/opt \
    HOME=/opt \
    DISPLAY=:665
COPY ./baidunetdisk_4.17.7_amd64.deb /tmp/baidu.deb
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y /tmp/baidu.deb \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/baidu.deb \
    && mkdir -p /opt/Desktop \
    && mkdir -p /opt/Downloads \
    && mkdir -p /opt/.config/baidunetdisk \
    && ln -s /usr/share/applications/baidunetdisk.desktop /opt/Desktop \
    && ln -s /usr/share/applications/pcmanfm.desktop /opt/Desktop


FROM baidunetdisk
EXPOSE 6650
COPY run.sh /opt/run.sh
CMD ["bash","/opt/run.sh"]
