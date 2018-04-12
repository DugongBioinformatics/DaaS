FROM ubuntu:xenial
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>

############### Environment config
ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash

RUN apt-get install linuxmint-keyring \
    && echo "deb http://packages.linuxmint.com/ sylvia main" >> /etc/apt/sources.list.d/mint.list \
    && apt-get update && apt-get install -y --allow-unauthenticated git curl wget vim sudo build-essential pwgen \
    fuse automake cmake sed grep dpkg openjdk-8-jre pkg-config ca-certificates mercurial subversion finger \
    p7zip-rar p7zip-full unace unrar zip unzip bzip2 sharutils rar uudeview mpack arj   \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && wget --quiet  https://github.com/krallin/tini/releases/download/v0.16.1/tini \
    && mv tini /usr/local/bin/tini && chmod +x /usr/local/bin/tini
    
# Language/locale settings
#   replace en_US by your desired locale setting, 
#   for example de_DE for german.
ENV LANG en_US.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen \
    && apt-get install -y locales && update-locale --reset LANG=$LANG

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
