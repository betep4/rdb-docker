FROM centos:6.6
MAINTAINER Dmitriy Gorchakov "dmitry.gorchakov@red-soft.ru"

ARG RELEASE=2.6.0
ARG BUILD=13542
ARG ARCH=x86_64
ARG RELEASE_URL=http://builds.red-soft.biz/release_hub/rdb26/$RELEASE.$BUILD/download/red-database:linux-$ARCH:$RELEASE.$BUILD:tar.gz:cs

WORKDIR /

RUN yum clean all \
 && sed -i 's/mirrorlist=/#mirrorlist=/' /etc/yum.repos.d/CentOS-Base.repo \
 && sed -i 's/http:\/\/mirror.centos.org/https:\/\/vault.centos.org/' /etc/yum.repos.d/CentOS-Base.repo \
 && sed -i 's/#baseurl=/baseurl=/' /etc/yum.repos.d/CentOS-Base.repo \
 && yum install -y xinetd tar libgssapi_krb5.so libgssapi_krb5.so libkrb5.so libkrb5.so \
 && mkdir -p /opt/RedDatabase \
 && echo "URL: $RELEASE_URL" \
 && curl -s -L -o /tmp/rdb.tar.gz -O "$RELEASE_URL" \
 && tar -xf /tmp/rdb.tar.gz -C /opt/RedDatabase \
 && rm -rf /tmp/rdb.tar.gz \
 && touch /opt/RedDatabase/firebird.log

ADD firebird /etc/xinetd.d
ADD SYSDBA.password /opt/RedDatabase
ADD docker-entrypoint.sh /
ADD alias.py /

VOLUME /data

EXPOSE 3050/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tail -f /opt/RedDatabase/firebird.log"]
