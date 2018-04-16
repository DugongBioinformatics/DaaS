#!/bin/sh
set -e

groupadd docker
usermod -aG docker $USER

systemctl enable docker

dockerd \
  --host=unix:///var/run/docker.sock \
  --host=tcp://0.0.0.0:2375 \
  &> /var/log/docker.log 2>&1 < /dev/null &
