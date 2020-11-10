FROM php:7.3.24-cli-alpine3.12

ENV SWOOLE_VERSION 4.5.6

RUN echo "https://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories \
    && echo "https://mirrors.aliyun.com/alpine/edge/community/" >> /etc/apk/repositories \
    && apk --update add git yarn tar gzip curl git wget g++ gcc zip make autoconf openssl-dev libzip libzip-dev libpng libpng-dev openssh-client oniguruma-dev \
    && wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O swoole.tar.gz \
    && yarn --version \
    && node --version \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip gd mbstring bcmath calendar fileinfo \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && ( \
    cd swoole \
    && /usr/local/bin/phpize \
    && ./configure --enable-openssl \
    && make \
    && make install \
    ) \
    && sed -i "2i extension=swoole.so" /usr/local/etc/php/php.ini \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer -V \
    && /usr/local/bin/composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && /usr/local/bin/composer self-update --clean-backups \
    && /usr/local/bin/composer global require phpmd/phpmd --no-suggest --no-ansi --no-interaction \
    && ln -s /srv/vendor/bin/phpmd /usr/local/bin/phpmd \
    && mkdir -p /root/.ssh \
    && rm -r swoole \
    && curl -L -o /tmp/reids.tar.gz https://github.com/phpredis/phpredis/archive/5.2.1.tar.gz \
    && cd /tmp && tar -xzf reids.tar.gz \
    && docker-php-source extract \
    && mv phpredis-5.2.1 /usr/src/php/ext/phpredis \
    && docker-php-ext-install phpredis
