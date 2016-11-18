FROM sstrigler/squeeze
MAINTAINER Stefan Strigler <stefan@strigler.de>

RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    php5-cgi php5-mysql php5-gd php5-suhosin php5-xcache \
    mysql-client \
    lighttpd \
    logrotate \
    && rm -rf /var/lib/apt/lists/*

COPY etc /etc

EXPOSE 80
VOLUME ["/var/www", "/var/log/lighttpd" ]

CMD ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
