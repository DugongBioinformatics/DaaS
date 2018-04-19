FROM x11docker/xfce
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - \
     && apt-key export "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88" | gpg - \
     && add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable" \
     && apt-get update && apt-get -y -q --no-install-recommends install docker-ce \
     && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker
EXPOSE 2375
CMD ["wrapdocker"]
