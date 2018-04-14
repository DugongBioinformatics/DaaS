##################################################################################################
# dugong/cinnamon
# 
# Run cinnamon desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github:
#   https://github.com/DugongBioinformatics/x11docker 
#   https://github.com/mviereck/x11docker 
#
# Run desktop with:
#   x11docker --desktop --dbus-system dugong/cinnamon
#  or with systemd:
#   x11docker --desktop --systemd dugong/cinnamon
#
# Run single application:
#   x11docker dugong/cinnamon nemo
#
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
# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.1"

##################################################################################################

RUN apt-get update && apt-mark hold iptables && apt-get install -y --allow-unauthenticated \
    dbus-x11 procps psmisc mesa-utils mesa-utils-extra libxv1 libxv-dev xdg-utils xdg-user-dirs menu menu-xdg \
    mime-support desktop-file-utils cinnamon cinnamon-l10n dconf-cli dconf-editor gedit gnome-system-monitor \
    gnome-terminal pulseaudio sudo synaptic libglu1-mesa-dev \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# startscript to copy dotfiles from /etc/skel
# runs either CMD or image command from docker run
RUN echo '#! /bin/sh\n\
[ -e \$HOME/.cinnamon ] || {\n\
  dconf write /org/cinnamon/desktop/background/picture-uri \"'file:///usr/share/backgrounds/gnome/Sandstone.jpg'\"\n\
}\n\
[ -e "$HOME/.config" ] || cp -R /etc/skel/. $HOME/ \n\
exec $* \n\
' > /usr/local/bin/start \
    && chmod +x /usr/local/bin/start \
    && chown -R $USER:$USER $HOME
    
# Install CUDA

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

# Install VIRTUALGL

RUN curl -sSL \
    https://downloads.sourceforge.net/project/virtualgl/"${VIRTUALGL_VERSION}"/virtualgl_"${VIRTUALGL_VERSION}"_amd64.deb \
    -o virtualgl_"${VIRTUALGL_VERSION}"_amd64.deb \
    && dpkg -i virtualgl_*_amd64.deb \
    && /opt/VirtualGL/bin/vglserver_config -config +s +f -t \
    && rm virtualgl_*_amd64.deb

USER $USER
WORKDIR $HOME/data

ENTRYPOINT ["/usr/local/bin/start"]
CMD ["cinnamon-session"]

ENV DEBIAN_FRONTEND newt
