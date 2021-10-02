# 基础镜像
FROM ubuntu:16.04

# build参数
ARG user=qt

# 元数据
LABEL maintainer="fzzjoy" email="fzz_joy@163.com"

# 从构建上下文目录中的文件复制到新的一层的镜像内的位置
COPY qt-opensource-linux-x64-5.12.6.run /tmp/qt/

# 安装依赖
RUN apt-get update \
    && apt-get install -y \
    libxcb-keysyms1-dev \
    libxcb-image0-dev \
    libxcb-shm0-dev \
    libxcb-icccm4-dev \
    libxcb-sync0-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libx11-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxrender-dev \
    libxcb1-dev \
    libx11-xcb-dev \
    libxcb-glx0-dev \
    x11vnc \
    xauth \
    build-essential \
    mesa-common-dev \
    libglu1-mesa-dev \
    libxkbcommon-dev \
    libxcb-xkb-dev \
    libxslt1-dev \
    libgstreamer-plugins-base0.10-dev \
    libxkbcommon-x11-0 \
    sudo \
    && chmod +x /tmp/qt/qt-opensource-linux-x64-5.12.6.run

# 添加用户：赋予sudo权限，指定密码
RUN useradd --create-home --no-log-init --shell /bin/bash ${user} \
    && adduser ${user} sudo \
    && echo "${user}:1" | chpasswd

# 指定工作目录
WORKDIR /home/${user}

# 指定登录用户
USER ${user}

# 指定docker run时执行的程序
ENTRYPOINT /tmp/qt/qt-opensource-linux-x64-5.12.6.run