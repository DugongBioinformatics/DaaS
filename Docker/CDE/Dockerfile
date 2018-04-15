##################################################################################################
# Dugong - Scientific Linux Containers for Bioinformatics
# ========================================================
#
# Current development is led by Fabiano Menegidio.
#
# Bioinformatician/Bioinformaticist at the Laboratory of Functional 
# and Structural Genomics of the Integrated Nucleus of Biotechnology 
# at the University of Mogi das Cruzes, Brazil.
# 
# Contact: fabiano.menegidio@biology.bio.br
# GitHub: https://github.com/fabianomenegidio
# GitHub: https://github.com/DugongBioinformatics
#
#========================================================
# RUN DUGONG CDE DESKTOP IN DOCKER:
#
# Use x11docker to run image. 
# Get x11docker from github:
#   https://github.com/mviereck/x11docker 
#   https://github.com/DugongBioinformatics/x11docker 
#
# Run desktop with:
#   x11docker --desktop --dbus-system dugong/cde
# or with systemd:
#   x11docker --desktop --systemd dugong/cde
#
# Run single application:
#   x11docker dugong/cde nemo
#
# Run VNC application:
#   read Xenv < <(x11docker --desktop --dbus-system --showenv dugong/cde)
#   echo $Xenv
#   env $Xenv x11vnc -noshm -forever -localhost -rfbport 5910
#
# Options:
# Persistent home folder stored on host with   --home
# Shared host folder with                      --sharedir DIR
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Sound support with option                    --alsa or --pulseaudio
#
# See x11docker --help for further options.
##################################################################################################

FROM dugong/daas:base
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>

##################################################################################################

LABEL base.image="dugong/daas:base" \
      version="201804" \
      name="Dugong" \
      flavour="CDE" \
      base="Ubuntu xenial" \
      description="Scientific Linux Container" \
      website="https://fabianomenegidio.github.io/dugong-bioinformatics/" \
      repository="https://github.com/fabianomenegidio/dugong-bioinformatics" \
      license="MIT" \
      tags="Bioinformatics"

##################################################################################################

USER root

##################################################################################################

ENV DEBIAN_FRONTEND noninteractive
ENV PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/sbin:/usr/sbin:/usr/dt/bin:${PATH}

##################################################################################################

RUN wget -O - http://sparkylinux.org/repo/sparkylinux.gpg.key | apt-key add - \
    && echo "deb https://sparkylinux.org/repo/ testing main" >/etc/apt/sources.list.d/sparky.list \
    && apt-get update && apt-mark hold iptables && apt-get install -y --allow-unauthenticated \
    dbus-x11 procps psmisc xdg-utils xdg-user-dirs menu menu-xdg libjpeg62-dev libjpeg-dev libjpeg8-dev \
    libjpeg-turbo8-dev mime-support desktop-file-utils cde-desktop \
    && apt-get --fix-missing install && apt --fix-broken install \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && chown -R $USER:$USER $HOME
    
##################################################################################################

USER $USER
WORKDIR $HOME/data

CMD ["/usr/dt/bin/startxsession.sh"]

ENV DEBIAN_FRONTEND newt
