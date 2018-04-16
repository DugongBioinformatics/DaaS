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

RUN apt-get update && apt-get install -y --allow-unauthenticated git curl wget vim sudo build-essential pwgen \
    fuse automake cmake sed grep dpkg openjdk-8-jre pkg-config ca-certificates mercurial subversion finger \
    unrar zip unzip bzip2 rar arj locales xterm fakeroot dh-make gnupg2 \
    && apt-get --fix-missing install && apt --fix-broken install \
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

# startscript to copy dotfiles from /etc/skel
# runs either CMD or image command from docker run
RUN echo '#! /bin/sh\n\
    [ -n "$HOME" ] && [ ! -e "$HOME/.config" ] && cp -R /etc/skel/. $HOME/ \n\
    exec $*\n\
' > /usr/local/bin/start \
    && chmod +x /usr/local/bin/start 

ENTRYPOINT ["/usr/local/bin/start"]
ENTRYPOINT ["tini", "--"]
CMD ["/bin/bash"]
