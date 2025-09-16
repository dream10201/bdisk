FROM docker.io/xiuxiu10201/webvnc:latest AS baidunetdisk
ENV \
    XDG_CONFIG_HOME=/opt \
    XDG_CACHE_HOME=/opt \
    HOME=/opt \
    DISPLAY=:665 \
    WEB_PORT=6650
RUN  \
    && wget --no-check-certificate -q "https://media.githubusercontent.com/media/dream10201/bdisk/refs/heads/master/bin/baidunetdisk_4.17.7_amd64.deb?download=true" -O /tmp/tmp.deb \
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
