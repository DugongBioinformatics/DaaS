#!/bin/bash

supervisord --configuration /.config/supervisord.conf
sleep 10
chown -R $UID:$UID $HOME/workdir/data
