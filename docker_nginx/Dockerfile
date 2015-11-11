FROM ubuntu:14.04.3

MAINTAINER MITHUN

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -o Dpkg::Options::='--force-confold' --force-yes -fuy dist-upgrade

RUN apt-get update && \
    apt-get install nginx sed dnsutils -yq

# apt clean
RUN apt-get clean &&\
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

#ADD ssl/domain_crt_with_bundle.cer /root/ssl/
#ADD ssl/domain.key /root/ssl/

ADD conf/fluentd-source.conf /opt/utils/fluentd-source.conf
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN usermod -a -G adm td-agent

RUN rm -rf /etc/nginx/sites-enabled/default
ADD conf/default /etc/nginx/sites-enabled/default
ADD start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80 443

CMD ["supervisord"]
