ARG PHP_VERSION=""
FROM php:${PHP_VERSION:-7.0-apache}
LABEL maintainer="Juan Luis Baptiste <juan@juanbaptiste.tech>"

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions exif gd gettext mysqli opcache pdo_mysql zip

RUN apt update && apt install -y apache2 && \
    a2enmod rewrite && \
    a2enmod headers && \
    a2enmod proxy && \
    a2enmod proxy_fcgi && \
    a2enmod deflate && \
    a2enmod proxy expires

COPY run.sh /
RUN  chmod 755 /run.sh
ENTRYPOINT ["/run.sh"]
