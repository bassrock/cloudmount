FROM lsiobase/ubuntu:bionic

# global environment settings
ENV PLATFORM_ARCH="amd64"
ARG RCLONE_VERSION="current"
ARG RCLONE_SITE="downloads"
ARG MERGERFS_VERSION="2.28.3"

ENV MERGERFS_OPTIONS="defaults,nonempty,category.action=all,category.create=epff,minfreespace=0,allow_other,auto_cache,sync_read,umask=0002,func.getattr=newest"

# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

ENV FILE_TO_WAIT=/mnt/rclone/test

RUN apt-get update && \
    apt-get install -y git unionfs-fuse wget unzip
    
RUN mkdir -p /tmp && \ 
	cd /tmp && \
    wget -q https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb && \
    dpkg -i mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb && \
    rm -rf mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb
    
RUN mkdir -p /tmp && \ 
	cd /tmp && \
    wget -q https://${RCLONE_SITE}.rclone.org/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    unzip /tmp/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin && \
    rm -rf /tmp/rclone-*-linux-${PLATFORM_ARCH} && \
    rm -rf /tmp/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip

# add local files
COPY root/ /

VOLUME /config /mnt/mergerfs /mnt/google /mnt/local

ENTRYPOINT ["/init"]
