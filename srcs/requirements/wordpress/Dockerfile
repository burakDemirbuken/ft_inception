FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install -y php-fpm php

CMD ["php-fpm", "-F"]
