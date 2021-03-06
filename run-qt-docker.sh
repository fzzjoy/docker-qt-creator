#!/bin/bash
user=`who -s -u -q | awk 'NR==1' | cut -d ' ' -f 1 2>&1`
echo "user is ${user}"

# N.B. This is an important step any time you're running GUIs in containers
xhost local:root

# run image
docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
           -e DISPLAY=$DISPLAY \
           -v /dev/shm:/dev/shm \
           -v ~/src:/home/${user}/src \
           -v ~/.config/Qt:/home/${user}/.config/Qt \
           -v ~/.config/QtProject:/home/${user}/.config/QtProject \
           --device /dev/dri \
           --name qt_creator \
           --rm \
           --entrypoint /home/${user}/Qt5.12.6/Tools/QtCreator/bin/qtcreator \
           qt:latest