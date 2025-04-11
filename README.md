# bdisk
毒盘linux无头环境
## 拉取镜像
```bash
docker pull docker.io/xiuxiu10201/bdisk:latest
// or
docker pull ghcr.io/dream10201/bdisk:latest
```
## 运行命令
```shell
docker run --name=bd \
--user 0:0
--env PASSWORD=123456 \
--env DISPLAY_WIDTH=1920 \
--env DISPLAY_HEIGHT=1080 \
--rm --network=host -d \
--env TZ=Asia/Shanghai \
docker.io/xiuxiu10201/bdisk:latest
```

## Web
[http://localhost:6650/vnc.html](http://localhost:6650/vnc.html)

## 环境变量

| 名称 | 描述 | 必须|
|:---------:|:---------:|:---------:|
|PASSWORD|VNC密码|Y|
|DISPLAY_WIDTH|窗口宽度|N|
|DISPLAY_HEIGHT|窗口高度|N|

## 挂载目录

| 路径 | 描述 | 必须|
|:---------:|:---------:|:---------:|
|/opt/.config/baidunetdisk|数据目录|N|
|/opt/Downloads|下载目录|N|

## 端口占用
| 端口 | 描述 | 必须|
|:---------:|:---------:|:---------:|
|6650|WEB端口|Y|
|6565|VNC端口|N|
