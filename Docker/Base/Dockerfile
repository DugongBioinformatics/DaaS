
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

USER root

##################################################################################################

ENV DEBIAN_FRONTEND noninteractive

##################################################################################################

RUN apt-get update \
    && apt-get install -y --allow-unauthenticated apt-transport-https software-properties-common libgtk-3-bin \
    libgtk-3-common libgtk-3-0:amd64 libgtk-3-dev \
    && apt-get --fix-missing install && apt --fix-broken install \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##################################################################################################

ADD install.sh ./install.sh
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x ./install.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh \
    && ./install.sh


ENTRYPOINT ["docker-entrypoint.sh"]
