FROM 0x01be/retroarch:build as build

FROM 0x01be/xpra

COPY --from=build /opt/retroarch/ /opt/retroarch/
COPY --from=build /lib/* /usr/lib/

USER root

RUN apk add --no-cache --virtual libretro-runtime-dependencies \
    eudev \
    ffmpeg \
    freetype \
    libxml2 \
    mesa \
    zlib \
    wayland \
    qt5-qtbase \
    py3-qt5 \
    mesa-dri-swrast

RUN mkdir -p /home/xpra/.config/retroarch
RUN ln -s /opt/retroarch/cores /home/xpra/.config/retroarch/cores
RUN ln -s /opt/retroarch/share/retroarch/assets /home/xpra/.config/retroarch/assets
RUN chown -R xpra:xpra /home/xpra/

USER xpra

WORKDIR /home/xpra/.config/retroarch
ENV PATH ${PATH}:/opt/retroarch/bin/
ENV COMMAND retroarch

