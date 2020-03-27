ARG PHP_VERSION=""
FROM php:${PHP_VERSION:-7.0-apache}
LABEL maintainer="Juan Luis Baptiste <juan@juanbaptiste.tech>"

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions exif gd gettext mysqli opcache pdo_mysql zip

RUN a2enmod rewrite && \
    a2enmod headers

COPY run.sh /
RUN  chmod 755 /run.sh
ENTRYPOINT ["/run.sh"]
