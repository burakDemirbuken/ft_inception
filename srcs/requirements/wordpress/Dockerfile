FROM debian:bullseye

RUN apt-get update && apt-get install -y php7.4-fpm php7.4-mysql wget mariadb-client
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp-cli

RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY ./tool/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

WORKDIR /var/www/html

ENTRYPOINT [ "/usr/local/bin/init.sh" ]

CMD ["php-fpm7.4", "--nodaemonize"]
