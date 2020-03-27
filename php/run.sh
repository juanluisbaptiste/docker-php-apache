#!/bin/bash
set -x

SERVER_NAME="${SERVER_NAME:-localhost}"
PHP_UPLOAD_MAX_SIZE="${PHP_UPLOAD_MAX_SIZE:-2G}"
PHP_MEMORY_LIMIT="${PHP_MEMORY_LIMIT:-128M}"
PHP_TIMEOUT=${PHP_TIMEOUT:-180}
APACHE_CONF_FILE="/etc/apache2/sites-enabled/000-default.conf"

PHP_CONF_DIR="/usr/local/etc/php/"
PHP_INI_FILE="${PHP_CONF_DIR}php.ini"
cp /usr/local/etc/php/php.ini-production ${PHP_INI_FILE}

sed -i -e "s#memory_limit = .*#memory_limit = $PHP_MEMORY_LIMIT#g" ${PHP_INI_FILE}
sed -i -e "s#max_input_time = .*#max_input_time = $PHP_TIMEOUT#g" ${PHP_INI_FILE}
sed -i -e "s#default_socket_timeout = .*#default_socket_timeout = $PHP_TIMEOUT#g" ${PHP_INI_FILE}
sed -i -e "s#post_max_size = .*#post_max_size = $PHP_UPLOAD_MAX_SIZE#g" ${PHP_INI_FILE}
sed -i -e "s#upload_max_filesize = .*#upload_max_filesize = $PHP_UPLOAD_MAX_SIZE#g" ${PHP_INI_FILE}
sed -i -e "s/#ServerName .*/ServerName ${SERVER_NAME}/g" ${APACHE_CONF_FILE}

if [ "$PHP_ENABLE_ERRORS" != "TRUE" ]; then
  sed -i -e "\#php_flag[display_errors]#d" ${PHP_INI_FILE}
fi

### Timezone Config
echo "date.timezone="`cat /etc/timezone` >> ${PHP_CONF_DIR}conf.d/timezone.ini
sed -i -e "s#date.timezone = .*#date.timezone = `cat /etc/timezone`#g" ${PHP_INI_FILE}

# Run default entrypoint
/usr/local/bin/docker-php-entrypoint apache2-foreground
