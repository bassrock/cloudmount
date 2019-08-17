FROM lsiobase/ubuntu:bionic

# global environment settings
ARG MERGERFS_VERSION="2.28.1"
ARG RCLONE_VERSION="current"
ARG RCLONE_SITE="downloads"
ENV PLATFORM_ARCH="amd64"
# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

# MERGERFS MOUNTS
ENV MERGERFS_OPTIONS="cache.files=off,async_read=false,func.getattr=newest,category.create=ff,xattr=nosys,statfs_ignore=ro,noatime,minfreespace=0,use_ino,umask=002,allow_other,nonempty"
ENV MERGERFS_LOCAL_RWMODE="RW"
ENV MERGERFS_RCLONE_RWMODE="NC"

# RCLONE
ENV RCLONE_REMOTE="google:"
ENV RCLONE_USER_AGENT="cloudmount/1.0"
ENV RCLONE_UPLOAD_CMD="move"
ENV RCLONE_BWLIMIT="80M"
ENV RCLONE_DRIVE_CHUNK_SIZE="128M"
ENV RCLONE_MOUNT_OPTIONS="--dir-cache-time=60m"
ENV RCLONE_HEALTH_CHECK_FILE=.test
# These are paths relative to the root of the local/remote volumes.
ENV RCLONE_UPLOAD_LOCAL_PATH=
ENV RCLONE_UPLOAD_REMOTE_PATH=

RUN apt-get update && apt-get install -y git unionfs-fuse wget unzip && rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p /tmp && \ 
	cd /tmp && \
    wget -q https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb && \
    dpkg -i mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb && \
    rm -rf mergerfs_${MERGERFS_VERSION}.ubuntu-bionic_amd64.deb && \
    rm -rf /tmp/*
    
RUN mkdir -p /tmp && \ 
	cd /tmp && \
    wget -q https://${RCLONE_SITE}.rclone.org/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    unzip /tmp/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin && \
    rm -rf /tmp/rclone-*-linux-${PLATFORM_ARCH} && \
    rm -rf /tmp/rclone-${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip && \
    rm -rf /tmp/*

# add local files
COPY root/ /

VOLUME ["/config", "/data"]

ENTRYPOINT ["/init"]
