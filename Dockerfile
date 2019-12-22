FROM debian:buster-slim
LABEL MAINTAINER="Swoopla <p.vibet@gmail.com>"

USER root

# copy assets to image
COPY ./assets /usr/local

# install antivirus and dependencies, get the latest clamav and maldet signatures
RUN apt-get update && \
    apt-get install -y apt-utils clamav clamav-daemon curl inotify-tools supervisor host tar wget && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/log/cron && \
    cd /usr/local/ && chmod +x *.sh && sync && \
    cd /usr/local/bin && chmod +x *.sh && sync && \
    /usr/local/install_maldet.sh && \
    /usr/local/install_antivirus.sh && \
    apt-get -y remove curl apt-utils && \
    rm -rf /var/cache/*

RUN freshclam && \
    maldet -u -d

# export volumes (uncomment if you do not mount these volumes at runtime or via docker-compose)
VOLUME [/data/av/queue, /data/av/ok, /data/av/nok]

ENTRYPOINT ["/usr/local/entrypoint.sh"]
