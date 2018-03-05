# x11docker/xfce
# 
# Run XFCE desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: x11docker --desktop dugong/xfce
#           x11docker dugong/xfce thunar 

FROM ubuntu:latest
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>

# ===================================================================================================
# Base packages
# ===================================================================================================

# X11 support
RUN apt-get update && apt-get install -y apt-utils dbus-x11 x11-utils x11-xserver-utils procps psmisc

# OpenGL support
RUN apt-get install -y mesa-utils mesa-utils-extra libxv1

# Language/locale settings
ENV LANG=en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale
RUN apt-get install -y locales

# Some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs
RUN apt-get install -y menu menu-xdg mime-support desktop-file-utils desktop-base

# Xfce
RUN apt-get install -y --no-install-recommends xfce4 
RUN apt-get install -y xfce4-terminal mousepad xfce4-notifyd 

# Includes GTK3 broadway support for HTML5 web applications
RUN apt-get install -y --no-install-recommends libgtk-3-bin

# Additional Xfce panel plugins
RUN apt-get install -y --no-install-recommends xfce4-battery-plugin \
    xfce4-clipman-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin \
    xfce4-netload-plugin xfce4-notes-plugin xfce4-places-plugin \
    xfce4-sensors-plugin xfce4-systemload-plugin \
    xfce4-whiskermenu-plugin xfce4-indicator-plugin \
    xfce4-cpufreq-plugin xfce4-diskperf-plugin xfce4-fsguard-plugin \
    xfce4-genmon-plugin xfce4-smartbookmark-plugin xfce4-timer-plugin \
    xfce4-verve-plugin xfce4-weather-plugin
    
# Additional Xfce goodies
RUN apt-get install -y xfce4-taskmanager gtk3-engines-xfce

# ===================================================================================================
# Additional packages
# ===================================================================================================

RUN apt-get update && apt-get install -y --allow-unauthenticated make grep sed sudo dpkg git wget zip \
    build-essential bzip2 ca-certificates vim gdebi-core bash-completion apt-utils openjdk-8-jre ksh \
    openssh-server unzip curl ruby net-tools icedtea-8-plugin zlib1g-dev libqt4-dbus libqt4-network \
    chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg screen mlocate nano asciinema \
    sysstat libssl-dev libsqlite3-dev libbz2-dev libreadline-dev checkinstall libreadline-gplv2-dev \
    libncursesw5-dev tk-dev libgdbm-dev libc6-dev libffi-dev libxslt1-dev libxml2-dev libtinfo-dev \
    libcurl4-openssl-dev libc-dev-bin libreadline6-dev 

# ===================================================================================================
# Bioinformatics packages
# ===================================================================================================

ENV SCIENV_ROOT $HOME/.scienv
ENV PATH $HOME/.scienv/bin:$HOME/.scienv/envs:$PATH

RUN git clone https://github.com/LaBiOS/scienv.git $HOME/.scienv \
        && echo 'export HOME="$HOME"' >> $HOME/.bash_profile \
        && echo 'export PATH="$HOME/.scienv/bin:$HOME/.scienv/envs:$PATH"' >> $HOME/.bash_profile \
        && echo 'export SCIENV_ROOT="$HOME/.scienv"' >> $HOME/.bash_profile \
        && echo 'eval "$(scienv init -)"' >> $HOME/.bash_profile \
        && echo 'export HOME="$HOME"' >> $HOME/.bashrc \
        && echo 'export PATH="$HOME/.scienv/bin:$HOME/.scienv/envs:$PATH"' >> $HOME/.bashrc \
        && echo 'export SCIENV_ROOT="$HOME/.scienv"' >> $HOME/.bashrc \
        && echo 'eval "$(scienv init -)"' >> $HOME/.bashrc \ 
        && export PATH="$HOME/.scienv/bin:$HOME/.scienv/envs:$PATH" \
        && eval "$($HOME/.scienv/bin/scienv init -)" \
        && /bin/bash -c "exec $SHELL -l"

ENV PYENV_ROOT $HOME/.scienv/envs/pyenv
ENV PYENV $HOME/.scienv/envs/pyenv/bin:$HOME/.scienv/envs/pyenv/shims:$HOME/.scienv/envs/pyenv/envs:$HOME/.scienv/envs/pyenv:$HOME/.scienv/envs/pyenv/plugins
ENV PYTHON-BUILD $HOME/.scienv/envs/pyenv/plugins/python-build/bin
ENV PYENV-DOCTOR $HOME/.scienv/envs/pyenv/plugins/pyenv-doctor/bin
ENV PYENV-INSTALLER $HOME/.scienv/envs/pyenv/plugins/pyenv-installer/bin
ENV PYENV-UPDATE $HOME/.scienv/envs/pyenv/plugins/pyenv-update/bin
ENV PYENV-VIRTUALENV $HOME/.scienv/envs/pyenv/plugins/pyenv-virtualenv/bin
ENV PYENV-WHICH-EXT $HOME/.scienv/envs/pyenv/plugins/pyenv-which-ext/bin
ENV PATH $HOME/.scienv/bin:$HOME/.scienv/envs:$PYENV:$PATH

RUN scienv install pyenv \
    && echo 'eval "$(pyenv init -)"' >> $HOME/.bash_profile \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bash_profile \
    && echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.bash_profile \
    && echo 'export PYENV_ROOT="$HOME/.scienv/envs/pyenv"' >> $HOME/.bash_profile \
    && echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc \
    && echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc \
    && echo 'export PYENV_VIRTUALENV_DISABLE_PROMPT=1' >> $HOME/.bashrc \
    && echo 'export PYENV_ROOT="$HOME/.scienv/envs/pyenv"' >> $HOME/.bashrc \
    && eval "$($PYENV_ROOT/bin/pyenv init -)" \
    && eval "$($PYENV_ROOT/bin/pyenv virtualenv-init -)" \
    && /bin/bash -c "exec $SHELL -l" \
    && /bin/bash -c "source $HOME/.bashrc" \
    && /bin/bash -c "source $HOME/.bash_profile" \
    && /bin/bash -c "source $PYENV_ROOT/completions/pyenv.bash" 

# ===================================================================================================
# Additional configs
# ===================================================================================================

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Create startscript 
RUN echo '#! /bin/bash\n\
[ -e "$HOME/.config" ] || cp -R /etc/skel/. $HOME/ \n\
exec startxfce4\n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

CMD start
