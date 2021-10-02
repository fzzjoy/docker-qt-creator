#!/bin/bash
user=`who -s -u -q | awk 'NR==1' | cut -d ' ' -f 1 2>&1`
echo "user is ${user}"

# Build base image （在Dockerfile的目录下执行）
docker build --build-arg user=${user} -t qt:base .
if [ $? -eq 0 ];then
  echo 'docker build finish'
else
  echo 'docker build failed ' $?
  exit -1
fi

# N.B. This is an important step any time you're running GUIs in containers
xhost local:${user}

# Run installation wizard, save to new image, delete left over container
docker run \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    -v /dev/shm:/dev/shm \
    --device /dev/dri \
    --name qt_install \
    --entrypoint /tmp/qt/qt-opensource-linux-x64-5.12.6.run \
    qt:base
if [ $? -eq 0 ];then
  echo 'docker run finish'
else
  echo 'docker run failed ' $?
  exit -1
fi

docker commit qt_install qt:latest
if [ $? -eq 0 ];then
  echo 'docker commit finish'
else
  echo 'docker commit failed ' $?
  exit -1
fi

docker rm qt_install