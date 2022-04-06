FROM ubuntu

MAINTAINER Steve Gall <steve.gall@me.com>

ENV helmVersion "2.11.0"
ENV kubectlVersion "1.15.0"
ENV jamalVersion "1.0.1"

RUN apt-get update
RUN apt-get install -y \
        curl \
        wget \
        dnsutils \
        htop \
        jq \
        lsof \
        netcat \
        nmap \
        unzip \
        ssh \
        tcpflow \
        vim

RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O /opt/awscliv2.zip \
    && unzip -d /opt /opt/awscliv2.zip \
    && /opt/aws/install \
    && rm /opt/awscliv2.zip \
    && wget https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && wget -O /tmp/jamal.gz https://github.com/quantumew/jamal/releases/download/v1.0.1/jamal-Linux-arm64.tar.gz \
    && cd /tmp \
    && tar -xvzf /tmp/jamal.gz -C /usr/local/bin jamal \
    && rm -f /tmp/jamal.gz \
    && chmod a+x /usr/local/bin/kubectl /usr/local/bin/jamal \
    && wget -O /tmp/mongo.tgz https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2004-x86_64-100.5.2.tgz \
    &&  tar -xvzf /tmp/mongo.tgz -C /tmp \
    &&  mv /tmp/mongodb-database-tools-ubuntu2004-x86_64-100.5.2/bin/* /usr/local/bin \
    &&  rm -rf /tmp/mongodb-database-tools-ubuntu2004-x86_64-100.5.2 \
    &&  rm /tmp/mongo.tgz
RUN rm -rf /var/lib/apt/lists/*
COPY scripts/*.sh /root
RUN chmod 700 /root/backup.sh \
    && chmod 700 /root/restore.sh
