FROM lsiobase/ubuntu

# global environment settings
ENV PLATFORM_ARCH="amd64"
ARG RCLONE_VERSION="current"
ARG RCLONE_SITE="downloads"
ARG MERGER_VERSION="2.26.1"



# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

ENV FILE_TO_WAIT=/mnt/rclone/test

RUN apt-get update && \
    apt-get install -y git unionfs-fuse wget unzip
    
RUN mkdir -p /tmp && \ 
	cd /tmp && \
    wget -q https://github.com/trapexit/mergerfs/releases/download/${MERGER_VERSION}/mergerfs_${MERGER_VERSION}.ubuntu-xenial_amd64.deb && \
    dpkg -i mergerfs_${MERGER_VERSION}.ubuntu-xenial_amd64.deb && \
    rm -rf mergerfs_${MERGER_VERSION}.ubuntu-xenial_amd64.deb
    
RUN mkdir -p /tmp && \ 
	cd /tmp && \
    wget -q https://${RCLONE_SITE}.rclone.org/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    unzip /tmp/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin && \
    rm -rf /tmp/rclone-*-linux-${PLATFORM_ARCH} && \
    rm -rf /tmp/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip

# add local files
COPY root/ /

VOLUME /config /mnt/unionfs /mnt/google /mnt/local

ENTRYPOINT ["/init"]
