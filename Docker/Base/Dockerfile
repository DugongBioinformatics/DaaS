FROM dugong/daas:minimal
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>

##################################################################################################

LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

##################################################################################################

USER root

##################################################################################################

ENV DEBIAN_FRONTEND noninteractive
ENV VIRTUALGL_VERSION 2.5.2
ENV PATH /usr/local/nvidia/bin:/opt/VirtualGL/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
ENV CUDA_VERSION 9.1.85
ENV CUDA_PKG_VERSION 9-1=$CUDA_VERSION-1
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.1"

##################################################################################################

RUN dpkg --configure -a \
    && apt-get update \
    && apt-get install -y --allow-unauthenticated apt-transport-https software-properties-common \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

##################################################################################################
# Install CUDA
##################################################################################################

RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 \
    && NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 \
    && apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub \
    && apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub \
    && echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub \
    && echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list \
    && echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get update && apt-get install -y --no-install-recommends cuda-cudart-$CUDA_PKG_VERSION \
    && ln -s cuda-9.1 /usr/local/cuda \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

##################################################################################################
# Install VIRTUALGL
##################################################################################################

RUN curl -sSL \
    https://downloads.sourceforge.net/project/virtualgl/"${VIRTUALGL_VERSION}"/virtualgl_"${VIRTUALGL_VERSION}"_amd64.deb \
    -o virtualgl_"${VIRTUALGL_VERSION}"_amd64.deb \
    && dpkg -i virtualgl_*_amd64.deb \
    && /opt/VirtualGL/bin/vglserver_config -config +s +f -t \
    && rm virtualgl_*_amd64.deb

##################################################################################################
# Install docker
##################################################################################################

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && apt-key export "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88" | gpg - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" >> /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get -y -q --no-install-recommends install docker-ce \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
VOLUME /var/lib/docker
EXPOSE 2375

##################################################################################################
