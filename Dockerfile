FROM centos:6.6
MAINTAINER Dmitriy Gorchakov "dmitry.gorchakov@red-soft.ru"

ARG RELEASE=4.0.0
ARG BUILD=2508
ARG ARCH=x86_64
ARG RELEASE_URL=http://builds.red-soft.biz/release_hub/rdb40/$RELEASE.$BUILD/download/red-database:linux-$ARCH-enterprise:$RELEASE.$BUILD:tar.gz

WORKDIR /

RUN yum install -y libtommath libicu tar \
 && mkdir -p /tmp/RedDatabase \
 && mkdir -p /opt/RedDatabase \
 && echo "URL: $RELEASE_URL" \
 && curl -s -L -o /tmp/rdb.tar.gz -O "$RELEASE_URL" \
 && tar -xf /tmp/rdb.tar.gz -C /tmp/RedDatabase \
 && rm -rf /tmp/rdb.tar.gz \
 && cp -r /tmp/RedDatabase/RedDatabase-$RELEASE.$BUILD-$ARCH/. /opt/RedDatabase \
 && rm -rf /tmp/RedDatabase \
 && touch /opt/RedDatabase/firebird.log \
 && sed -i -e 's/^#RemoteFileOpenAbility.*0$/RemoteFileOpenAbility = 1/' /opt/RedDatabase/firebird.conf \
 && sed -i -e 's/^#UserManager = Srp$/UserManager = Legacy_UserManager/' /opt/RedDatabase/firebird.conf \
 && sed -i -e 's/^#WireCrypt = .*/WireCrypt = Disabled/' /opt/RedDatabase/firebird.conf \
 && sed -i -e '/^#AuthClient.*#Windows clients$/a\AuthClient = Legacy_Auth, Srp, WinSspi' /opt/RedDatabase/firebird.conf

ADD SYSDBA.password /opt/RedDatabase
ADD reddatabase /etc/rc.d/init.d
ADD docker-entrypoint.sh /
ADD alias.py /

VOLUME /data

ENV SERVER_MODE=Super
ENV AUTH_SERVER=Legacy_Auth
ENV REMOTE_AUX_PORT=6001

EXPOSE 3050/tcp
EXPOSE 6000-7000/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tail -f /opt/RedDatabase/firebird.log"]
