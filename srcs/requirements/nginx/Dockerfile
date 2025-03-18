FROM debian:bullseye

RUN apt-get update -y && apt-get install -y; apt-get install -y nginx openssl net-tools

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes \
	-days 365 \
	-newkey rsa:4096 \
	-keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
	-subj "/C=TR/ST=Kocaeli/L=Kocaeli/O=41/OU=41/CN=NABERMUDUR"

COPY ./config.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
