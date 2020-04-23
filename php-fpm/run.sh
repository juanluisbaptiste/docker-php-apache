#!/bin/bash
set -x

SERVER_NAME="${SERVER_NAME:-localhost}"
PHP_UPLOAD_MAX_SIZE="${PHP_UPLOAD_MAX_SIZE:-2G}"
PHP_MEMORY_LIMIT="${PHP_MEMORY_LIMIT:-128M}"
PHP_TIMEOUT=${PHP_TIMEOUT:-180}
PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-"2G"}
PHP_FPM_MAX_CHILDREN=${PHP_FPM_MAX_CHILDREN:-75}
PHP_FPM_MAX_REQUESTS=${PHP_FPM_MAX_REQUESTS:-500}
PHP_FPM_MAX_SPARE_SERVERS=${PHP_FPM_MAX_SPARE_SERVERS:-3}
PHP_FPM_MIN_SPARE_SERVERS=${PHP_FPM_MIN_SPARE_SERVERS:-1}
PHP_FPM_PROCESS_MANAGER=${PHP_FPM_PROCESS_MANAGER:-"dynamic"}
PHP_FPM_START_SERVERS=${PHP_FPM_START_SERVERS:-2}

PHP_CONF_DIR="/usr/local/etc/php/"
PHP_INI_FILE="${PHP_CONF_DIR}php.ini"
PHP_FPM_CONF_FILE="/usr/local/etc/php-fpm.d/www.conf"
cp /usr/local/etc/php/php.ini-production ${PHP_INI_FILE}

sed -i -e "s#memory_limit = .*#memory_limit = ${PHP_MEMORY_LIMIT}#g" ${PHP_INI_FILE}
sed -i -e "s#max_input_time = .*#max_input_time = ${PHP_TIMEOUT}#g" ${PHP_INI_FILE}
sed -i -e "s#default_socket_timeout = .*#default_socket_timeout = ${PHP_TIMEOUT}#g" ${PHP_INI_FILE}
sed -i -e "s#post_max_size = .*#post_max_size = ${PHP_UPLOAD_MAX_SIZE}#g" ${PHP_INI_FILE}
sed -i -e "s#upload_max_filesize = .*#upload_max_filesize = ${PHP_UPLOAD_MAX_SIZE}#g" ${PHP_INI_FILE}

sed -i -e "s#pm.max_children = .*#pm.max_children = ${PHP_FPM_MAX_CHILDREN}#g" ${PHP_FPM_CONF_FILE}
# sed -i -e "s#<MAX_EXECUTION_TIME>#$PHP_TIMEOUT#g" ${PHP_FPM_CONF_FILE}
sed -i -e "s#.*pm.max_requests = .*#pm.max_requests = ${PHP_FPM_MAX_REQUESTS}#g" ${PHP_FPM_CONF_FILE}
sed -i -e "s#pm.max_spare_servers = .*#pm.max_spare_servers = ${PHP_FPM_MAX_SPARE_SERVERS}#g" ${PHP_FPM_CONF_FILE}
sed -i -e "s#pm.start_servers = .*#pm.start_servers = ${PHP_FPM_START_SERVERS}#g" ${PHP_FPM_CONF_FILE}
sed -i -e "s#pm.min_spare_servers = .*#pm.min_spare_servers = ${PHP_FPM_MIN_SPARE_SERVERS}#g" ${PHP_FPM_CONF_FILE}
sed -i -e "s#php_admin_value[memory_limit] = .*#php_admin_value[memory_limit] = ${PHP_MEMORY_LIMIT}#g" ${PHP_FPM_CONF_FILE}
sed -i -e "s#php_admin_value[post_max_size] = .*#php_admin_value[post_max_size] = ${PHP_POST_MAX_SIZE}#g" ${PHP_FPM_CONF_FILE}
sed -i -e "s#pm = .*>#pm = ${PHP_FPM_PROCESS_MANAGER}#g" ${PHP_FPM_CONF_FILE}
sed -i -e "s#php_admin_value[upload_max_filesize] = .*#php_admin_value[upload_max_filesize] = ${PHP_UPLOAD_MAX_SIZE}#g" ${PHP_FPM_CONF_FILE}

if [ "$PHP_ENABLE_ERRORS" != "TRUE" ]; then
  sed -i -e "\#php_flag[display_errors]#d" ${PHP_INI_FILE}
fi

### Timezone Config
echo "date.timezone="`cat /etc/timezone` >> ${PHP_CONF_DIR}conf.d/timezone.ini
sed -i -e "s#date.timezone = .*#date.timezone = `cat /etc/timezone`#g" ${PHP_INI_FILE}

# Run default entrypoint
/usr/local/bin/docker-php-entrypoint php-fpm
