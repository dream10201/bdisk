FROM debian:stable-slim AS base
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    DEBIAN_FRONTEND=noninteractive
RUN apt update \
    && apt install --no-install-recommends -y ca-certificates x11-xkb-utils xkbset wget curl unzip locales fonts-noto-cjk \
    && locale-gen zh_CN.UTF-8 \
    && echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

FROM base AS desktop
ENV G_SLICE=always-malloc
RUN apt install --no-install-recommends -y pcmanfm tint2 openbox xauth xinit

FROM desktop AS tigervnc
RUN wget --no-check-certificate -qO- https://sourceforge.net/projects/tigervnc/files/stable/1.15.0/tigervnc-1.15.0.x86_64.tar.gz | tar xz --strip 1 -C /


FROM tigervnc AS novnc
ENV NO_VNC_HOME=/usr/share/usr/local/share/noVNCdim
RUN apt install --no-install-recommends -y python3-numpy libxshmfence1 libasound2 libxcvt0 libgbm1 \
    && mkdir -p "${NO_VNC_HOME}/utils/websockify" \
    && wget --no-check-certificate -qO- "https://github.com/novnc/noVNC/archive/v1.6.0.tar.gz" | tar xz --strip 1 -C "${NO_VNC_HOME}" \
    && wget --no-check-certificate -qO- "https://github.com/novnc/websockify/archive/v0.13.0.tar.gz" | tar xz --strip 1 -C "${NO_VNC_HOME}/utils/websockify" \
    && chmod +x -v "${NO_VNC_HOME}/utils/novnc_proxy" \
    && sed -i '1s/^/if(localStorage.getItem("resize") == null){localStorage.setItem("resize","remote");}\n/' "${NO_VNC_HOME}/app/ui.js" \
    && rm -rf /usr/share/doc /usr/share/man

FROM novnc AS baidunetdisk
ENV \
    XDG_CONFIG_HOME=/opt \
    XDG_CACHE_HOME=/opt \
    HOME=/opt \
    DISPLAY=:665
RUN  \
    wget --no-check-certificate -q "https://media.githubusercontent.com/media/dream10201/bdisk/refs/heads/master/bin/baidunetdisk_4.17.7_amd64.deb?download=true" -O /tmp/tmp.deb \
    && DEBIAN_FRONTEND=noninteractive apt install --allow-unauthenticated --no-install-recommends -y /tmp/tmp.deb \
    && rm -rf /tmp/tmp.deb \
    && mkdir -p /opt/Desktop \
    && mkdir -p /opt/Downloads \
    && mkdir -p /opt/.config/baidunetdisk \
    && ln -s /usr/share/applications/baidunetdisk.desktop /opt/Desktop \
    && ln -s /usr/share/applications/pcmanfm.desktop /opt/Desktop \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


FROM baidunetdisk
EXPOSE 6650
COPY run.sh /opt/run.sh
CMD ["bash","/opt/run.sh"]
