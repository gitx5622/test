FROM yiisoftware/yii2-php:7.2-apache

RUN a2enmod rewrite

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/html/test/

# Set working directory
WORKDIR /var/www/html/test

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    nano \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --prefer-dist --optimize-autoloader --no-dev && \
    composer clear-cache && \
    composer update

# Install extensions
#RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
#RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
#RUN docker-php-ext-install gd

# Copy existing application directory contents
COPY . /var/www/html/test

RUN mkdir -p runtime web/assets && \
    chmod -R 777 runtime web/assets && \
    chown -R www-data:www-data runtime web/assets
# Expose port 9000 and start php-fpm server
EXPOSE 8888

CMD ["yiisoftware/yii2-php:7.2-apache"]
