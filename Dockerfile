FROM 0x01be/retroarch:build as build

FROM 0x01be/xpra

COPY --from=build /opt/retroarch/ /opt/retroarch/

USER root

RUN apk add --no-cache --virtual libretro-runtime-dependencies \
    eudev \
    ffmpeg \
    freetype \
    libxml2 \
    mesa \
    zlib

USER xpra

ENV PATH ${PATH}:/opt/retroarch/bin/
ENV COMMAND retroarch

