FROM php:7.1.31-cli-alpine3.10

ENV SWOOLE_VERSION 4.4.12

RUN echo "https://mirrors.aliyun.com/alpine/v3.10/main/" > /etc/apk/repositories \
    && apk --update add git tar gzip curl wget g++ gcc zip unzip make autoconf openssl-dev libpng libpng-dev openssh-client \
    && wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O swoole.tar.gz \
    && docker-php-ext-install gd zip mbstring bcmath calendar fileinfo \
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
    && mv composer.phar /usr/bin/composer \
    && composer self-update --clean-backups \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && composer global require phpmd/phpmd --no-suggest --no-ansi --no-interaction \
    && ln -s /srv/vendor/bin/phpmd /usr/local/bin/phpmd \
    && mkdir -p /root/.ssh \
    && rm -r swoole
