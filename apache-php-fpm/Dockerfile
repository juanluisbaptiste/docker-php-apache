FROM php:${PHP_VERSION:-7.0-fpm}
LABEL maintainer="Juan Luis Baptiste <juan@juanbaptiste.tech>"

ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN apt update && apt install -y apache2 && \
    chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions apcu \
    exif \
    gd \
    gettext \
    gmp \
    iconv \
    imagick \
    imap \
    mysqli \
    opcache \
    pdo_mysql \
    zip
RUN a2enmod rewrite && \
    a2enmod headers && \
    a2enmod proxy && \
    a2enmod proxy_fcgi && \
    a2enmod deflate && \
    a2enmod proxy expires
COPY run.sh /
COPY config/*.ini /usr/local/etc/php/conf.d/
COPY apache2/modules/*.conf /etc/apache2/conf-enabled/
COPY apache2/*.conf /etc/apache2/sites-available/
RUN  chmod 755 /run.sh
ENTRYPOINT ["/run.sh"]
