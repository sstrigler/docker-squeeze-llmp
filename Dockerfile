FROM sstrigler/squeeze-llmp
MAINTAINER Stefan Strigler <stefan@strigler.de>

RUN apt-get update
RUN apt-get install -y lighttpd-mod-magnet
RUN rm -rf /var/lib/apt/lists/*

COPY etc /etc
COPY bsde /var/www

RUN mkdir -p /home/blogsport/blogsport.de/htdocs
RUN ln -s /var/www/wp-inst /home/blogsport/blogsport.de/htdocs/wp-inst

RUN chown -R www-data /var/www/wp-inst/wp-content/cache
RUN chown -R www-data /var/www/wp-inst/wp-content/smarty-cache

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
