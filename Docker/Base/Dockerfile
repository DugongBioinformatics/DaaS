###########################################################################
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
###########################################################################

FROM ubuntu:xenial
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>

############### Environment config
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash

RUN apt-key adv --recv-key --keyserver keyserver.ubuntu.com "A5D32F012649A5A9" \
    && echo "deb http://packages.linuxmint.com sylvia main upstream import backport" >> /etc/apt/sources.list.d/mint.list \
    && echo "deb http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list \
    && echo "deb http://archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list \
    && echo "deb http://archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list \
    && echo "deb http://security.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list \
    && echo "deb http://archive.canonical.com/ubuntu/ xenial partner" >> /etc/apt/sources.list.d/ubuntu.list \
    && apt-get update && apt-get install -y --allow-unauthenticated git curl wget vim sudo build-essential pwgen \
    fuse automake cmake sed grep dpkg openjdk-8-jre pkg-config ca-certificates mercurial subversion finger \
    unrar zip unzip bzip2 rar arj locales xterm fakeroot dh-make gnupg2 software-properties-common \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && wget --quiet  https://github.com/krallin/tini/releases/download/v0.16.1/tini \
    && mv tini /usr/local/bin/tini && chmod +x /usr/local/bin/tini
    
# Language/locale settings
#   replace en_US by your desired locale setting, 
#   for example de_DE for german.
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV LANG C.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen \
    && update-locale --reset LANG=$LANG \
    && locale-gen en_US.UTF-8 

############### Create User and Password

ENV USER dugong
ENV HOME /headless

RUN export PASS="$(pwgen -1 12)" \
    && useradd -d $HOME --shell /bin/bash --user-group --groups adm,sudo $USER \
    && echo "$USER:$PASS" | chpasswd \
    && echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p $HOME/data \
    && mkdir -p $HOME/.ve \
    && mkdir -p $HOME/.workspace \
    && ln -s $HOME/.ve $HOME/data/.ve && ln -s $HOME/.workspace $HOME/data/.workspace \
    && echo "############### Welcome to Minimal Dugong ###############"  > $HOME/.login \
    && echo "############## User: $USER - Pass: $PASS ##############" >> $HOME/.login \
    && chown -R $USER:$USER $HOME

USER $USER
WORKDIR $HOME/data

ENTRYPOINT ["tini", "--"]
VOLUME ["$HOME/data"]
CMD ["/bin/bash"]

RUN cat $HOME/.login
