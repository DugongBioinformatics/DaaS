FROM ubuntu:18.04

##############################################################################
# Metadata
##############################################################################
LABEL \
    "maintainer"="Fabiano Menegidio <fabiano.menegidio@biology.bio.br>" \
    "dugong.version"=$DUGONG_VERSION \
    "dugong.flavor"=$DUGONG_FLAVOR \
    # Kubernetes Labels
    "io.k8s.description"="All-in-one web-based development environment for machine learning." \
    "io.k8s.display-name"="Dugong DaaS" \
    # Openshift labels: https://docs.okd.io/latest/creating_images/metadata.html
    "io.openshift.expose-services"="8080:http, 5901:xvnc" \
    "io.openshift.non-scalable"="true" \
    "io.openshift.tags"="workspace, machine learning, vnc, ubuntu, xfce" \
    "io.openshift.min-memory"="1Gi" \
    # Open Container labels: https://github.com/opencontainers/image-spec/blob/master/annotations.md
    "org.opencontainers.image.title"="Machine Learning Workspace" \
    "org.opencontainers.image.description"="All-in-one web-based development environment for machine learning." \
    "org.opencontainers.image.documentation"="https://github.com/ml-tooling/ml-workspace" \
    "org.opencontainers.image.url"="https://github.com/ml-tooling/ml-workspace" \
    "org.opencontainers.image.source"="https://github.com/ml-tooling/ml-workspace" \
    "org.opencontainers.image.licenses"="Apache-2.0" \
    "org.opencontainers.image.version"=$WORKSPACE_VERSION \
    "org.opencontainers.image.vendor"="ML Tooling" \
    "org.opencontainers.image.authors"="Lukas Masuch & Benjamin Raehtlein" \
    "org.opencontainers.image.revision"=$ARG_VCS_REF \
    "org.opencontainers.image.created"=$ARG_BUILD_DATE \ 
    "org.label-schema.name"="Machine Learning Workspace" \
    "org.label-schema.description"="All-in-one web-based development environment for machine learning." \
    "org.label-schema.usage"="https://github.com/ml-tooling/ml-workspace" \
    "org.label-schema.url"="https://github.com/ml-tooling/ml-workspace" \
    "org.label-schema.vcs-url"="https://github.com/ml-tooling/ml-workspace" \
    "org.label-schema.vendor"="ML Tooling" \
    "org.label-schema.version"=$WORKSPACE_VERSION \
    "org.label-schema.schema-version"="1.0" \
    "org.label-schema.vcs-ref"=$ARG_VCS_REF \
    "org.label-schema.build-date"=$ARG_BUILD_DATE
    

##############################################################################
# VERSIONS: full, minimal, light, gpu, ml
##############################################################################   
ARG ARG_DUGONG_FLAVOR="full"
ENV DUGONG_FLAVOR=$ARG_DUGONG_FLAVOR

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
ENV SCIF_PATH="/resources/scif"
ENV NB_USER="root"
ENV PYTHON_VERSION="Miniconda3-latest"
ENV JUPYTER_PORT=8888
ENV CONDA_DIR="$HOME/.conda"
ENV CONDA_PYTHON_DIR="/opt/conda/lib/python3.6"
ENV LD_LIBRARY_PATH="$CONDA_DIR/lib"
ENV PATH $CONDA_DIR:$CONDA_DIR/bin:/usr/local/openresty/nginx/sbin:/opt/node/bin:$PATH
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"
ENV LANG="C.UTF-8"
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

WORKDIR $HOME

##############################################################################
# Create folders
##############################################################################
RUN mkdir $RESOURCES_PATH && chmod a+rwx $RESOURCES_PATH \
    && mkdir $WORKDIR_HOME && chmod a+rwx $WORKDIR_HOME \
    && mkdir $SSL_RESOURCES_PATH && chmod a+rwx $SSL_RESOURCES_PATH \
    && mkdir $SCIF_PATH && chmod a+rwx $SCIF_PATH
    
COPY resources/scif/* /resources/scif/
COPY resources/nginx/lua-extensions /etc/nginx/nginx_plugins
COPY resources/nginx/nginx.conf /etc/nginx/nginx.conf
COPY resources/ssh/ssh_config resources/ssh/sshd_config  /etc/ssh/
COPY resources/config/xrdp.ini /etc/xrdp/xrdp.ini
COPY resources/config/supervisord.conf /etc/supervisor/supervisord.conf
COPY resources/config/90assumeyes /etc/apt/apt.conf.d/
COPY resources/tools/* /resources/tools
COPY resources/scripts/clean-layer.sh /usr/bin/clean-layer.sh
COPY resources/scripts/fix-permissions.sh /usr/bin/fix-permissions.sh


##############################################################################
# Install base dependencies
##############################################################################
RUN apt-get update --fix-missing \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y apt-utils software-properties-common ca-certificates \
    apt-transport-https \
    && add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" \
    && apt-get upgrade -y && apt-get update \
    && apt-get install -y --allow-unauthenticated --no-install-recommends  \
    build-essential bash-completion net-tools locales screen unzip util-linux \
    xterm git curl libcurl4 wget vim dpkg automake cmake sed grep gnupg2 pwgen \
    lsof cron openssl tmux nano sqlite3 xmlstarlet libhiredis-dev less tree fuse \
    iputils-ping locate jq rsync subversion mercurial jed unixodbc unixodbc-dev \
    libtiff-dev libjpeg-dev libpng-dev libjasper-dev libglib2.0-0 libxext6 libsm6 \
    libxext-dev libxrender1 libzmq3-dev protobuf-compiler autoconf libprotobuf-dev \
    google-perftools libprotoc-dev automake libtool cmake fonts-liberation zip arj \
    gzip unrar bzip2 lzop bsdtar zlib1g-dev pkg-config libgtk-3-bin libgtk-3-common \
    libgtk-3-0:amd64 libgtk-3-dev sudo htop \
    && apt-get --fix-missing install && apt --fix-broken install \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && wget --quiet  https://github.com/krallin/tini/releases/download/v0.16.1/tini \
    && mv tini /usr/local/bin/tini && chmod +x /usr/local/bin/tini \
    && chmod -R a+rwx /usr/local/bin/ \
    && ldconfig \
    && echo $LANG UTF-8 > /etc/locale.gen \
    && update-locale --reset LANG=$LANG \
    && locale-gen en_US.UTF-8 \
    && echo '#! /bin/sh\n \
    [ -n "$HOME" ] && [ ! -e "$HOME/.config" ] && cp -R /etc/skel/. $HOME/ \n \
    exec $*\n \
    ' > /usr/local/bin/start \
    && chmod +x /usr/local/bin/start \ 
    && chmod a+rwx /usr/bin/clean-layer.sh \ 
    && chmod a+rwx /usr/bin/fix-permissions.sh \
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
    && conda update --all && conda clean -tipsy \
    && \
##############################################################################
# Install packages through Scif
##############################################################################
    scif install $SCIF_PATH/nginx.scif \
    && scif install $SCIF_PATH/ssh.scif \
    && scif install $SCIF_PATH/nodejs.scif \
    && scif install $SCIF_PATH/jdk.scif \
    && scif install $SCIF_PATH/xfce4.scif \
    && scif install $SCIF_PATH/rdp.scif \
    && scif install $SCIF_PATH/supervisor.scif \
    && scif install $SCIF_PATH/python.scif \
    && scif install $SCIF_PATH/novnc.scif \
    && scif install $SCIF_PATH/gui_tools.scif

ENTRYPOINT ["/usr/local/bin/start"]
ENTRYPOINT ["tini", "--"]
CMD ["/bin/bash"]
