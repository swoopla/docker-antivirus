FROM debian:jessie-slim
LABEL maintainer "Cheewai Lai <cheewai.lai@gmail.com>"

ARG GOSU_VERSION=1.11

USER root

# copy assets to image
COPY ./assets /usr/local

# install antivirus and dependencies, get the latest clamav and maldet signatures
RUN apt-get update && \
    apt-get install -y apt-utils clamav clamav-daemon curl inotify-tools supervisor host tar wget chkconfig rsync && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/log/cron && \
    cd /usr/local/ && chmod +x *.sh && sync && \
    cd /usr/local/bin && chmod +x *.sh && sync && \
    /usr/local/install_maldet.sh && \
    /usr/local/install_antivirus.sh && \
    curl -o gosu -kfsSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" && \
    mv gosu /usr/bin/gosu && \
    chmod +x /usr/bin/gosu && \
    apt-get -y remove curl apt-utils && \
    rm -rf /var/cache/* && \
    # Enable SafeBrowsing, https://www.clamav.net/documents/safebrowsing \
    sed -i -e 's/^SafeBrowsing.*/SafeBrowsing yes/' /etc/clamav/freshclam.conf && \
    # Update in entrypoint so that they are persisted into mounted volumes \
    #freshclam && \
    #maldet -u -d \
    cp -a /usr/local/maldetect /usr/local/maldetect.ORIG

# export volumes (uncomment if you do not mount these volumes at runtime or via docker-compose)
# VOLUME /data/av/queue
# VOLUME /data/av/ok
# VOLUME /data/av/nok

ENTRYPOINT ["/usr/local/entrypoint.sh"]
