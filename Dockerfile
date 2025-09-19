FROM php:8.3.9-apache

# Composer version
ENV COMPOSER_VERSION=2.7.7

# Cài đặt package cần thiết + PHP extensions
RUN apt-get update && apt-get install -y \
        curl \
        zip \
        unzip \
        git \
        supervisor \
        libpng-dev \
        libpq-dev \
        libzip-dev \
        libexif-dev \
        gnupg \
        tzdata \
    && docker-php-ext-install \
        bcmath \
        gd \
        opcache \
        sockets \
        zip \
        exif \
        pdo_mysql \
        mysqli \
    && docker-php-ext-enable pdo_mysql

# Cài đặt Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Cấu hình Apache DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# Cài đặt Composer đúng version
RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/local/bin --filename=composer --version=$COMPOSER_VERSION

# Bật rewrite module cho Laravel / Symfony
RUN a2enmod rewrite

# Tạo user "app" thay vì chạy bằng root
RUN useradd -ms /bin/bash -u 1000 app

# Copy script start (nếu có)
# COPY start /usr/local/bin/
# CMD ["start"]

# Mặc định Apache foreground
CMD ["apache2-foreground"]
