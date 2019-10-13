# Reference: https://github.com/phpmyadmin/docker

ARG version

FROM php:${version}
MAINTAINER Andrew Yeung <andrew@compandsave.com>

LABEL app.name="php-fpm"
LABEL app.version="${version}"

# docker-entrypoint.sh dependencies
RUN apk add --no-cache \
    bash \
    git

# Install dependencies
RUN set -ex; \
    \
    apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        libzip-dev \
    ; \
    \
    docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-webp-dir=/usr --with-png-dir=/usr --with-xpm-dir=/usr; \
    docker-php-ext-install bz2 gd mysqli opcache zip; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --virtual .phpmyadmin-phpexts-rundeps $runDeps; \
    apk del .build-deps

# Install phpRedis
RUN set -ex; \
    \
    apk --no-cache add pcre-dev ${PHPIZE_DEPS}; \
    pecl install -o -f redis; \
    rm -rf /tmp/pear; \
    docker-php-ext-enable redis; \
    apk del pcre-dev ${PHPIZE_DEPS};

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini; \
    \
    { \
        echo 'session.cookie_httponly = 1'; \
        echo 'session.use_strict_mode = 1'; \
    } > /usr/local/etc/php/conf.d/session-strict.ini; \
    \
    { \
        echo 'allow_url_fopen = Off'; \
        echo 'max_execution_time = 600'; \
        echo 'memory_limit = 512M'; \
    } > /usr/local/etc/php/conf.d/phpmyadmin-misc.ini

# Copy configuration
COPY config.inc.php /tmp/

# Copy main script
COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY www.conf /usr/local/etc/php-fpm.d/
COPY php.ini /usr/local/etc/php/
COPY php-fpm.conf /usr/local/etc/

RUN addgroup -g 3000 app \
 && adduser -D -G app -u 3000 -H app

ENV html_volume=/var/www/html

VOLUME ${html_volume}

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["php-fpm"]
