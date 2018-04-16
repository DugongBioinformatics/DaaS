#!/bin/bash
set -e

/usr/sbin/init
systemctl enable docker
service restart docker

exec "$@"
