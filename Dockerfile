FROM ashafer01/ubuntu-base:18.04

ENV UNREAL_VERSION=4.2.4.1

# basic deps beyond ashafer01/ubuntu-base
RUN apt-get -y update && apt-get -y install file

# get the latest unreal source
WORKDIR /root/dockerbuild
ADD https://www.unrealircd.org/unrealircd4/unrealircd-$UNREAL_VERSION.tar.gz .
RUN tar -xzvf unrealircd-$UNREAL_VERSION.tar.gz && mkdir -p /opt/unreal

# configure the build, make, and install
WORKDIR unrealircd-$UNREAL_VERSION
RUN echo "#define FAKELAG_CONFIGURABLE" >> include/config.h
COPY config.settings .
RUN ./Config -quick && make && make install

# clean up
WORKDIR /opt/unreal
RUN chown -R irc:irc /opt/unreal && rm -rf /root/dockerbuild

VOLUME /opt/unreal/conf
VOLUME /opt/unreal/data
VOLUME /opt/unreal/logs

# start unreal
USER irc:irc
COPY docker-cmd.sh .
RUN chmod u+x docker-cmd.sh
CMD ["/opt/unreal/docker-cmd.sh"]

EXPOSE 6667
EXPOSE 6697
EXPOSE 7000
