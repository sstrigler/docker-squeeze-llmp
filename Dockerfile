FROM sstrigler/squeeze-llmp
MAINTAINER Stefan Strigler <stefan@strigler.de>

RUN apt-get update
RUN apt-get install -y lighttpd-mod-magnet
RUN rm -rf /var/lib/apt/lists/*

COPY etc /etc
COPY bsde /var/www

RUN mkdir -p /home/blogsport/blogsport.de/htdocs
RUN ln -s /var/www/wp-inst /home/blogsport/blogsport.de/htdocs/wp-inst

RUN chown www-data /var/www/wp-inst/wp-content/cache
RUN chown www-data /var/www/wp-inst/wp-content/smarty-cache
RUN ln -s /data /var/www/wp-inst/wp-content/blogs

EXPOSE 80

VOLUME /data

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
