FROM ashafer01/ubuntu-base:18.04

# install unreal package
COPY ashafer01-unrealircd4_*.deb /tmp/
RUN apt-get -y update && apt-get -y install /tmp/ashafer01-unrealircd4_*.deb

# copy in default configs
COPY --chown=irc:irc conf/* /opt/unreal/conf/

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
CMD ["/opt/unreal/bin/unrealircd", "-F"]
