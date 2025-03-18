FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y &&\
    apt-get install -y php php-fpm

RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

COPY ./www.conf /etc/php/7.4/fpm/pool.d/www.conf

CMD ["php-fpm7.4", "--nodaemonize"]
