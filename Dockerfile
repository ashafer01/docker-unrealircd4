##
## build
##
FROM ashafer01/ubuntu-base:18.04 AS build

ENV UNREAL_VERSION=4.2.4.1

RUN apt-get -y update && apt-get -y install \
    file \
    build-essential \
    wget

RUN mkdir -p /opt/unreal /tmp/build /tmp/deb /tmp/artifacts \
 && chown irc:irc /opt/unreal /tmp/build /tmp/deb /tmp/artifacts

USER irc:irc
COPY --chown=irc:irc \
    config.settings \
    build.sh \
    regen_cloak_keys.sh \
    /tmp/build/
COPY --chown=irc:irc deb-skel/ /tmp/deb/
WORKDIR /tmp

RUN /tmp/build/build.sh
LABEL stage=unreal-build


##
## production
##
FROM ashafer01/ubuntu-base:18.04

# install unreal package
COPY --from=build /tmp/artifacts/ashafer01-unrealircd4_*.deb /tmp/
RUN apt-get -y update && apt-get -y install /tmp/ashafer01-unrealircd4_*.deb

# copy in default configs
COPY --chown=irc:irc conf/* /opt/unreal/conf/

# copy in start script
COPY --chown=irc:irc docker-cmd.sh /opt/unreal/

# clean up
RUN rm -f /tmp/ashafer01-unrealircd4_*.deb \
 && apt-get -y clean \
 && apt-get -y autoclean \
 && apt-get -y autoremove

# expose things
VOLUME /opt/unreal/conf
VOLUME /opt/unreal/data
VOLUME /opt/unreal/logs

EXPOSE 6667
EXPOSE 6697
EXPOSE 7000

# start unreal
USER irc:irc
WORKDIR /opt/unreal
CMD ["/opt/unreal/docker-cmd.sh"]
