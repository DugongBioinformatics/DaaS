
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

FROM dugong/daas:minimal
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>

##################################################################################################

ENV DEBIAN_FRONTEND noninteractive

##################################################################################################

RUN apt-get update \
    && apt-get install -y --allow-unauthenticated apt-transport-https software-properties-common libgtk-3-bin \
    libgtk-3-common libgtk-3-0:amd64 libgtk-3-dev \
    && apt-get --fix-missing install && apt --fix-broken install \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##################################################################################################

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && apt-key export "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88" | gpg - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" >> /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get -y -q --no-install-recommends install docker-ce \
    && apt-get --fix-missing install && apt --fix-broken install \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && /bin/bash -c "service start docker"
    
VOLUME /var/lib/docker
EXPOSE 2375

