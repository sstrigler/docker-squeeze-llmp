FROM sstrigler/squeeze-llmp
MAINTAINER Stefan Strigler <stefan@strigler.de>

RUN apt-get update
RUN apt-get install -y lighttpd-mod-magnet
RUN rm -rf /var/lib/apt/lists/*

COPY etc /etc

RUN mkdir -p /home/blogsport/blogsport.de/htdocs
RUN ln -s /var/www/wp-inst /home/blogsport/blogsport.de/htdocs/wp-inst

EXPOSE 80

VOLUME /var/www

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
