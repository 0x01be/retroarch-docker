FROM arm32v6/alpine

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
    zlib-dev \
    alsa-lib-dev \
    wayland-dev \
    qt5-qtbase-dev \
    libpcap-dev

ENV LIBRETRO_REVISION master
RUN git clone --depth 1 --branch ${LIBRETRO_REVISION} git://github.com/libretro/libretro-super.git /libretro-super

RUN mkdir -p /opt/retroarch/cores

WORKDIR /libretro-super

ENV SHALLOW_CLONE 1
ENV NOCLEAN 1
RUN ./libretro-fetch.sh
RUN ./retroarch-build.sh
RUN ./libretro-build.sh

WORKDIR /libretro-super/retroarch
RUN make clean
RUN ./configure --prefix=/opt/retroarch
RUN make install

WORKDIR /libretro-super
RUN ./libretro-install.sh /opt/retroarch/cores

