FROM alpine

RUN apk add --no-cache --virtual libretro-build-dependencies \
    git \
    build-base \
    pkgconf \
    bash \
    eudev-dev \
    ffmpeg-dev \
    freetype-dev \
    libxml2-dev \
    mesa-dev \
    zlib-dev

ENV LIBRETRO_REVISION master
RUN git clone --depth 1 --branch ${LIBRETRO_REVISION} git://github.com/libretro/libretro-super.git /libretro-super

RUN mkdir -p /opt/retroarch/cores

WORKDIR /libretro-super

RUN apk add bash
ENV SHALLOW_CLONE 1
ENV NOCLEAN 1
RUN ./libretro-fetch.sh
RUN ./retroarch-build.sh
RUN ./libretro-build.sh

WORKDIR /libretro-super/retroarch
RUN make DESTDIR=/opt/retroarch install

WORKDIR /libretro-super
RUN ./libretro-install.sh /opt/retroarch/cores

