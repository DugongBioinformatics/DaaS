FROM ubuntu:18.04
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>
##############################################################################
# Metadata
##############################################################################
LABEL base.image="ubuntu:18.04"
LABEL name.image=""
LABEL version="1.0"
LABEL description=""
LABEL website=""
LABEL documentation=""
LABEL maintainer="Fabiano Menegidio"
LABEL python_version="3.7.7"
LABEL conda_version=""
LABEL scif_version=""
LABEL jupyter_version=""
LABEL CUDA_version=""
LABEL CUDNN_version=""
##############################################################################
# ARGs BUILD
##############################################################################
ARG ARG_BUILD_DATE="unknown"
ARG ARG_VCS_REF="unknown"
ARG ARG_WORKSPACE_VERSION="unknown"
ENV WORKSPACE_VERSION=$ARG_WORKSPACE_VERSION
##############################################################################
# GLOBAL ENVs
##############################################################################
ENV SHELL /bin/bash
ENV TERM="xterm"
ENV HOME /root
ENV USER_GID=0
ENV DEBIAN_FRONTEND noninteractive
ENV CUDA_VERSION 10.1.168
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV CUDNN_VERSION 7.6.0
ENV XDG_CACHE_HOME $HOME/.cache/
ENV XDG_RUNTIME_DIR="/tmp"
ENV DISPLAY=":1"
ENV RESOURCES_PATH="/resources"
ENV SSL_RESOURCES_PATH="/resources/ssl"
ENV WORKSPACE_HOME="/workspace"
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
##############################################################################
# LANGUAGE ENVs
##############################################################################
ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
##############################################################################
# CONDA ENVs
##############################################################################
ENV PYTHON3_VERSION Miniconda3-latest
ENV PYTHON2_VERSION Miniconda2-latest
ENV CONDA_DIR $HOME/.conda
ENV PYTHON_VERSION="3.7.7"
ENV CONDA_PYTHON_DIR $CONDA_DIR/lib/python3.7
ENV conda_env="py37"
ENV LD_LIBRARY_PATH $CONDA_DIR/lib
##############################################################################
# JUPYTER ENVs
##############################################################################
ENV JUPYTER_TYPE notebook
ENV JUPYTER_PORT 8888
ENV NB_USER="root"
##############################################################################
# VNC ENVs
##############################################################################
ENV VNC_PW=vncpassword
ENV VNC_RESOLUTION=1600x900
ENV VNC_COL_DEPTH=24
##############################################################################
# PATH
##############################################################################
ENV PATH $CONDA_DIR:$CONDA_DIR/bin:$PATH
##############################################################################
# COPY config files
##############################################################################
COPY config/start.sh /start.sh
COPY config/jupyter/start-notebook.sh /usr/local/bin/
COPY config/bashrc/.bashrc $HOME/.bashrc
COPY config/bashrc/.bash_profile $HOME/.bash_profile
COPY config/scripts/clean-layer.sh /usr/bin/clean-layer.sh
COPY config/scripts/fix-permissions.sh /usr/bin/fix-permissions.sh
COPY config/nginx/lua-extensions /etc/nginx/nginx_plugins
##############################################################################
# COPY packages files
##############################################################################
COPY config/scif/config_conda.scif /root/.packages/
COPY config/scif/cuda.scif /root/.packages/
COPY config/scif/cdnn.scif /root/.packages/
COPY config/scif/ssh.scif /root/.packages/
COPY config/scif/nginx.scif /root/.packages/
COPY config/scif/nodejs.scif /root/.packages/
COPY config/scif/jdk.scif /root/.packages/

##############################################################################
# Make folders and permission scripts
##############################################################################
RUN chmod a+rwx /usr/bin/clean-layer.sh \
    && chmod a+rwx /usr/bin/fix-permissions.sh \
    && mkdir $RESOURCES_PATH && chmod a+rwx $RESOURCES_PATH \
    && mkdir $WORKSPACE_HOME && chmod a+rwx $WORKSPACE_HOME \
    && mkdir $SSL_RESOURCES_PATH && chmod a+rwx $SSL_RESOURCES_PATH

##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################

##############################################################################
# Install base dependencies
##############################################################################
RUN apt-get update \
    && LIBPNG="$(apt-cache depends libpng-dev | grep 'Depends: libpng' | awk '{print $2}')" \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated \
    --no-install-recommends bash git zip wget libssl1.0.0 apt-utils \
    ca-certificates locales mlocate debconf curl build-essential \
    vim bzip2 sudo automake cmake sed grep x11-utils xvfb openssl \
    libxtst6 libxcomposite1 $LIBPNG stunnel swig libjpeg-dev libpng-dev libreadline-dev \
    apt-transport-https gnupg-agent gpg-agent gnupg2 pkg-config software-properties-common \
    lsof net-tools libcurl4 wget cron iproute2 psmisc tmux dpkg-sig uuid-dev csh xclip clinfo \
    libgdbm-dev libncurses5-dev gawk swig graphviz libgraphviz-dev screen nano locate sqlite3 \
    xmlstarlet libspatialindex-dev yara libhiredis-dev libpq-dev libmysqlclient-dev \
    libleptonica-dev libgeos-dev less tree bash-completion iputils-ping jq rsync subversion jed \
    unixodbc unixodbc-dev libtiff-dev libjpeg-dev libglib2.0-0 libxext6 libsm6 libxext-dev \
    libxrender1 libzmq3-dev protobuf-compiler libprotobuf-dev libprotoc-dev autoconf libtool \
    fonts-liberation google-perftools gzip unzip lzop bsdtar zlibc unp libbz2-dev liblzma-dev \
    zlib1g-dev liblapack-dev libatlas-base-dev libeigen3-dev libblas-dev libhdf5-dev libtesseract-dev \
    libjpeg-turbo8-dev \
    && apt-get clean && apt-get autoclean && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/ \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && ldconfig \
    && mkdir -p $HOME/workdir/data \
    && mkdir -p $HOME/workdir/notebooks \
    && chmod +x /start.sh \
    && chmod +x /usr/local/bin/start-notebook.sh \
    && chmod -R a+rwx /usr/local/bin/ \
    && fix-permissions.sh $HOME
    
##############################################################################
# Install Miniconda dependencies
##############################################################################
RUN wget --quiet https://repo.anaconda.com/miniconda/${PYTHON3_VERSION}-Linux-x86_64.sh \
    && /bin/bash ${PYTHON3_VERSION}-Linux-x86_64.sh -b -p ${CONDA_DIR} \
    && rm ${PYTHON3_VERSION}-Linux-x86_64.sh \
    && /bin/bash -c "exec $SHELL -l" \
    && /bin/bash -c "source $HOME/.bashrc" \
    && $HOME/.conda/bin/conda config --add channels conda-forge \
    && conda config --add channels bioconda \
    && conda config --add channels anaconda \
    && conda update --all && conda clean -tipy \
    && \
##############################################################################
# So we decided to use Python 3.7.7 as the container default.
# If you don't want to use these libraries, change your Python version to > 3.7.7.
##############################################################################
    conda create -n py37 python=3.7.7 -y

##############################################################################
# Default Conda Env
##############################################################################
ENV CONDA_DEFAULT_ENV $conda_env

##############################################################################
# Install Scif
##############################################################################
RUN python -m pip --no-cache-dir install --upgrade scif \
    && conda clean -tipy \
    && \
##############################################################################
# Install packages through Scif
##############################################################################
    scif install $HOME/.packages/config_conda.scif \
    && scif install $HOME/.packages/cuda.scif \
    && scif install $HOME/.packages/cdnn.scif \
    && scif install $HOME/.packages/ssh.scif \
    && scif install $HOME/.packages/nginx.scif \
    && scif install $HOME/.packages/nodejs.scif \
    && scif install $HOME/.packages/jdk.scif \
    
    
ENV PATH=/usr/local/openresty/nginx/sbin:$PATH
ENV PATH=/opt/node/bin:$PATH


EXPOSE 6000
EXPOSE 8888
VOLUME ["$HOME/workdir"]
#CMD ["/usr/local/bin/start-notebook.sh"]
