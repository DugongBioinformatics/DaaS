##############################################################################
# Dugong - Scientific Linux Containers for Bioinformatics
# ============================================================================
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
##############################################################################

FROM ubuntu:latest
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>

##############################################################################
# ENVs
##############################################################################
ENV DEBIAN_FRONTEND="noninteractive"
ENV SHELL="/bin/bash"
ENV HOME="/root"
ENV WORKDIR_HOME="/workdir"
ENV USER_GID=0
ENV XDG_CACHE_HOME="/root/.cache/"
ENV XDG_RUNTIME_DIR="/tmp"
ENV DISPLAY=":1"
ENV TERM="xterm"
ENV RESOURCES_PATH="/resources"
ENV SSL_RESOURCES_PATH="/resources/ssl" 
ENV NB_USER="root"
ENV PYTHON_VERSION="Miniconda3-latest"
ENV JUPYTER_PORT=8888
ENV CONDA_DIR="$HOME/.conda"
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV LANG C.UTF-8

WORKDIR $HOME

##############################################################################
# Create folders
##############################################################################
RUN mkdir $RESOURCES_PATH && chmod a+rwx $RESOURCES_PATH && \
    mkdir $WORKDIR_HOME && chmod a+rwx $WORKDIR_HOME && \
    mkdir $SSL_RESOURCES_PATH && chmod a+rwx $SSL_RESOURCES_PATH

##############################################################################
# Install base dependencies
##############################################################################
RUN apt-get update --fix-missing \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y sudo apt-utils \
    && apt-get upgrade -y && apt-get update \
    && apt-get install -y --allow-unauthenticated --no-install-recommends \
    build-essential software-properties-common python-software-properties \
    ca-certificates apt-transport-https net-tools locales bash-completion \
    xterm git curl libcurl3 wget vim dpkg automake cmake sed grep gnupg2 \
    lsof cron openssl tmux nano sqlite3 xmlstarlet libhiredis-dev less tree \
    iputils-ping locate jq rsync subversion mercurial jed unixodbc unixodbc-dev \
    libtiff-dev libjpeg-dev libpng-dev libpng12-dev libjasper-dev libglib2.0-0 \
    libxext6 libsm6 libxext-dev libxrender1 libzmq-dev protobuf-compiler autoconf \
    libprotobuf-dev libprotoc-dev automake libtool cmake fonts-liberation zip arj \
    google-perftools gzip unrar bzip2 lzop bsdtar zlib1g-dev pwgen fuse pkg-config \
    unzip util-linux libgtk-3-bin libgtk-3-common libgtk-3-0:amd64 libgtk-3-dev \
    && apt-get --fix-missing install && apt --fix-broken install \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && wget --quiet  https://github.com/krallin/tini/releases/download/v0.16.1/tini \
    && mv tini /usr/local/bin/tini && chmod +x /usr/local/bin/tini \
    && chmod -R a+rwx /usr/local/bin/ \
    && ldconfig \
    && echo $LANG UTF-8 > /etc/locale.gen \
    && update-locale --reset LANG=$LANG \
    && locale-gen en_US.UTF-8 
    && echo '#! /bin/sh\n\
    [ -n "$HOME" ] && [ ! -e "$HOME/.config" ] && cp -R /etc/skel/. $HOME/ \n\
    exec $*\n\
    ' > /usr/local/bin/start \
    && chmod +x /usr/local/bin/start \
    && \
##############################################################################
# Install Miniconda dependencies
##############################################################################
    wget --quiet https://repo.anaconda.com/miniconda/${PYTHON_VERSION}-Linux-x86_64.sh \
    && /bin/bash ${PYTHON_VERSION}-Linux-x86_64.sh -b -p ${CONDA_DIR} \
    && rm ${PYTHON_VERSION}-Linux-x86_64.sh \
    && /bin/bash -c "exec $SHELL -l" \
    && /bin/bash -c "source $HOME/.bashrc" \
    && conda config --add channels conda-forge \
    && conda config --add channels bioconda \
    && conda config --add channels anaconda \
    && pip --no-cache-dir install scif \
    && conda update --all && conda clean -tipsy

COPY /config/sudoers /etc/sudoers

ENTRYPOINT ["/usr/local/bin/start"]
ENTRYPOINT ["tini", "--"]
CMD ["/bin/bash"]
