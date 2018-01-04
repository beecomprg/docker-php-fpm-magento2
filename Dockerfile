#http://devdocs.magento.com/guides/v2.1/install-gde/system-requirements-tech.html
FROM php:7.0.26-fpm-alpine3.4

MAINTAINER Lukas Beranek <lukas@beecom.io>

#RUN apt-get update && apt-get install -y \
##  cron \ TODO FIXME resolve crons
#  libfreetype6-dev \
#  libicu-dev \
#  libjpeg62-turbo-dev \
#  libmcrypt-dev \
#  libpng12-dev \
#  libxslt1-dev \
#  mysql-client \
#  zip \
#  git
#
#RUN docker-php-ext-configure \
#  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
#
#RUN docker-php-ext-install \
#  bcmath \
#  gd \
#  intl \
#  mbstring \
#  mcrypt \
#  opcache \
#  pdo_mysql \
#  soap \
#  xsl \
#  zip
#
#RUN curl -sS https://getcomposer.org/installer | \
#  php -- --install-dir=/usr/local/bin --filename=composer
#
#RUN curl -O https://files.magerun.net/n98-magerun2.phar \
#    && chmod +x ./n98-magerun2.phar \
#    && mv ./n98-magerun2.phar /usr/local/bin/magerun2
#

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_PORT 9000
ENV PHP_PM dynamic
ENV PHP_PM_MAX_CHILDREN 10
ENV PHP_PM_START_SERVERS 4
ENV PHP_PM_MIN_SPARE_SERVERS 2
ENV PHP_PM_MAX_SPARE_SERVERS 6
ENV APP_MAGE_MODE default

COPY conf/www.conf /usr/local/etc/php-fpm.d/
COPY conf/php.ini /usr/local/etc/php/
COPY conf/php-fpm.conf /usr/local/etc/
COPY bin/* /usr/local/bin/

WORKDIR /var/www/html

RUN ["chmod", "+x", "/usr/local/bin/start"]

