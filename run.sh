#!/bin/bash
if [ -z "${DISPLAY_WIDTH}" ]; then
    DISPLAY_WIDTH=1366
fi
if [ -z "${DISPLAY_HEIGHT}" ]; then
    DISPLAY_HEIGHT=768
fi
export G_SLICE=always-malloc

mkdir -p "${HOME}/.vnc"
export PASSWD_PATH="${HOME}/.vnc/passwd"
echo ${PASSWORD} | vncpasswd -f >"${PASSWD_PATH}"
chmod 0600 "${HOME}/.vnc/passwd"
# 6565 = 5900 + 665
"${NO_VNC_HOME}"/utils/novnc_proxy --vnc localhost:$((5900+${DISPLAY#:})) --listen ${WEB_PORT} &
echo "geometry=${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" >~/.vnc/config
/usr/libexec/vncserver ${DISPLAY} &
sleep 2
pcmanfm --desktop &
tint2
