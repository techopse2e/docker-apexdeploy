FROM openjdk:jdk-alpine

ENV ANT_HOME /usr/share/java/apache-ant
ENV GOPATH /opt/go
ENV PATH $PATH:$ANT_HOME/bin:$GOPATH/bin
ENV VERSION 0.6.0-1

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
 
