#http://devdocs.magento.com/guides/v2.1/install-gde/system-requirements-tech.html
FROM php:7.0-fpm
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        imagemagick \
	libmagickwand-dev \
	libicu-dev \
        zlib1g-dev \
        libtool \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
#    && docker-php-ext-enable intl \
#    && docker-php-ext-install -j$(nproc) mbstring \
#    && docker-php-ext-install -j$(nproc) mcrypt \
#    && docker-php-ext-install -j$(nproc) hash \
#    && docker-php-ext-install -j$(nproc) pdo pdo_mysql \
#    && docker-php-ext-install -j$(nproc) simplexml \
#    && docker-php-ext-install -j$(nproc) openssl \
    && docker-php-ext-install -j$(nproc) soap \
#    && docker-php-ext-install -j$(nproc) xml \
#    && docker-php-ext-install -j$(nproc) xsl \
#    && docker-php-ext-configure -j$(nproc) xsl \
#    && docker-php-ext-install -j$(nproc) zip \
#    && docker-php-ext-install -j$(nproc) json \
#    && docker-php-ext-install -j$(nproc) iconv \
    && pecl install imagick \
    && docker-php-ext-enable imagick
    
