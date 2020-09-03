FROM yiisoftware/yii2-php:7.2-apache

RUN a2enmod rewrite

WORKDIR /app

ADD composer.lock composer.json /app/
RUN composer install --prefer-dist --optimize-autoloader --no-dev && \
    composer clear-cache

ADD yii /app/
ADD ./web /app/web/
ADD ./config /app/config

RUN mkdir -p runtime web/assets && \
    chmod -R 777 runtime web/assets && \
    chown -R www-data:www-data runtime web/assets
# Setup the custom configuration
ADD mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf