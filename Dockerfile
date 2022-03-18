ARG DEBIAN_VERSION=bullseye-slim 

##### Building stage #####
FROM debian:${DEBIAN_VERSION} as builder
MAINTAINER Vyacheslav Evstigneew <mail@evstigneew.com>

# Install dependencies
RUN apt-get update && \
	apt-get install -y \
		wget build-essential ca-certificates \
		openssl libssl-dev yasm git software-properties-common \
		libpcre3-dev librtmp-dev libtheora-dev \
		libvorbis-dev libvpx-dev libfreetype6-dev \
		libmp3lame-dev libx264-dev libx265-dev libass-dev \
		cmake libtool libc6 libc6-dev unzip libnuma1 libnuma-dev && \
	rm -rf /var/lib/apt/lists/*

RUN wget https://developer.download.nvidia.com/compute/cuda/11.6.1/local_installers/cuda_11.6.1_510.47.03_linux.run && \
	sh cuda_11.6.1_510.47.03_linux.run

# Download ffmpeg source
RUN cd /tmp/build && \
  wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  tar -zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  rm ffmpeg-${FFMPEG_VERSION}.tar.gz

# Download ffnvcodec and compile
RUN cd /tmp/build && \
	git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
	cd nv-codec-headers && \
	make -j $(getconf _NPROCESSORS_ONLN) && \
	make install
