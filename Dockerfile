#http://devdocs.magento.com/guides/v2.1/install-gde/system-requirements-tech.html
FROM php:7.1.30-fpm-alpine

MAINTAINER Lukas Beranek <lukas@beecom.io>

ENV APCU_VERSION 5.1.17
ENV REDIS_VERSION 4.2.0

#BUILD dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    freetype-dev \
    libjpeg-turbo-dev libxml2 libxml2-dev \
    patch \
    git

RUN apk add --no-cache --virtual .run-deps freetype libjpeg-turbo libpng-dev libpng icu-dev libmcrypt-dev libxslt-dev

RUN  docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(getconf _NPROCESSORS_ONLN) && \
  docker-php-ext-install -j${NPROC} gd

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$REDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv phpredis-* /usr/src/php/ext/redis

RUN docker-php-ext-install \
  bcmath \
  opcache \
  pdo_mysql \
  soap \
  zip \
  xsl \
  intl \
  redis \
  mcrypt \
  pcntl && \
  pecl install \
  apcu-${APCU_VERSION} && \
  docker-php-ext-enable --ini-name 20-apcu.ini apcu

#RUN export NEWRELIC_VERSION=$(curl -sS https://download.newrelic.com/php_agent/release/ | sed -n 's/.*>\(.*linux\).tar.gz<.*/\1/p') && \
#    curl -L -o newrelic.tar.gz https://download.newrelic.com/php_agent/release/$NEWRELIC_VERSION-musl.tar.gz && \
#    gzip -dc newrelic.tar.gz | tar xf - && \
#    cd $NEWRELIC_VERSION-musl && \
#    NR_INSTALL_SILENT=true NR_INSTALL_USE_CP_NOT_LN=true ./newrelic-install install && \
#    mv $PHP_INI_DIR/conf.d/newrelic.ini $PHP_INI_DIR/conf.d/20_newrelic.ini && \
#    cd .. && \
#    rm -rf $NEWRELIC_VERSION-musl && \
#    rm newrelic.tar.gz

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -O https://files.magerun.net/n98-magerun2.phar \
    && chmod +x ./n98-magerun2.phar \
    && mv ./n98-magerun2.phar /usr/local/bin/magerun2

#cleanup
RUN apk del --no-network .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/pear ~/.pearrc

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_PORT 9000
ENV PHP_PM dynamic
ENV PHP_PM_MAX_CHILDREN 10
ENV PHP_PM_START_SERVERS 4
ENV PHP_PM_MIN_SPARE_SERVERS 2
ENV PHP_PM_MAX_SPARE_SERVERS 6
ENV APP_MAGE_MODE default

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY conf/www.conf /usr/local/etc/php-fpm.d/
COPY conf/php.ini /usr/local/etc/php/
COPY conf/php-fpm.conf /usr/local/etc/
COPY bin/* /usr/local/bin/

WORKDIR /var/www/html
