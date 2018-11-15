FROM openjdk:jdk-alpine
  
ENV ANT_HOME /usr/share/java/apache-ant
ENV GOPATH /opt/go
ENV PATH $PATH:$ANT_HOME/bin:$GOPATH/bin
ENV VERSION 0.6.0-1
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 17.05.0-ce
ENV DOCKER_SHA256_x86_64 340e0b5a009ba70e1b644136b94d13824db0aeb52e09071410f35a95d94316d9
ENV DOCKER_SHA256_armel 59bf474090b4b095d19e70bb76305ebfbdb0f18f33aed2fccd16003e500ed1b7

RUN apk add --update \
    apache-ant --update-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    --allow-untrusted \
    bash \
    wget \
    git \
    go \
    g++ \
    mercurial \
    perl \
    zip \
    curl \
    make \
    openssh \
    openssl \
    openssl-dev && \
    rm -rf /var/cache/apk/* && \
    go get -u github.com/heroku/force && \
    cd $GOPATH/src/github.com/heroku/force && \
    go get . && \
    cp /opt/go/bin/force /usr/local/bin/ && \
    curl -L https://github.com/AGWA/git-crypt/archive/debian/$VERSION.tar.gz | tar zxv -C /var/tmp && \
    cd /var/tmp/git-crypt-debian-$VERSION && make && make install PREFIX=/usr/local && rm -rf /var/tmp/* && \
    apk del make openssl-dev

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz && \
    echo "${DOCKER_SHA256_x86_64} *docker.tgz" | sha256sum -c - && \
    tar -xzvf docker.tgz && \
    mv docker/* /usr/local/bin/ && \
    rmdir docker && \
    rm docker.tgz && \
    chmod +x /usr/local/bin/docker
