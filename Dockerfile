FROM yiisoftware/yii2-php:7.2-apache

# PHP Docker image for Yii 2.0 Framework runtime
# ==============================================
# Install system packages for PHP extensions recommended for Yii 2.0 Framework
# Set working directory

RUN a2enmod rewrite

WORKDIR /app

RUN apt-get update && \
    apt-get -y install \
        gnupg2 && \
    apt-key update && \
    apt-get update && \
    apt-get -y install \
            g++ \
            git \
            curl \
            imagemagick \
            libcurl3-dev \
            libicu-dev \
            libfreetype6-dev \
            libjpeg-dev \
            libjpeg62-turbo-dev \
            libonig-dev \
            libmagickwand-dev \
            libpq-dev \
            libpng-dev \
            libxml2-dev \
            libzip-dev \
            zlib1g-dev \
            default-mysql-client \
            openssh-client \
            nano \
            unzip \
            libcurl4-openssl-dev \
            libssl-dev \
        --no-install-recommends && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install PHP extensions required for Yii 2.0 Framework
# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd
# Environment settings
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PHP_USER_ID=33 \
    PHP_ENABLE_XDEBUG=0 \
    PATH=/app:/app/vendor/bin:/root/.composer/vendor/bin:$PATH \
    TERM=linux \
    VERSION_PRESTISSIMO_PLUGIN=^0.3.10

# Add GITHUB_API_TOKEN support for composer
RUN chmod 700 \
        /usr/local/bin/composer

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer.phar \
        --install-dir=/usr/local/bin && \
    composer clear-cache

# Install composer plugins
RUN composer global require --optimize-autoloader \
        "hirak/prestissimo:${VERSION_PRESTISSIMO_PLUGIN}" && \
    composer global dumpautoload --optimize && \
    composer clear-cache

ADD composer.lock composer.json /app/

#Composer install
RUN composer install --prefer-dist --optimize-autoloader --no-dev && \
    composer clear-cache

ADD yii /app/
ADD ./web /app/web/
ADD ./config /app/config

RUN mkdir -p runtime web/assets && \
    chmod -R 777 runtime web/assets && \
    chown -R www-data:www-data runtime web/assets
