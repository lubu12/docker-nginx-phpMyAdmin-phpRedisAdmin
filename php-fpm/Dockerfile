# Dockerfile Best Practice - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

# Advantage to have nginx and php in different containers
#   https://devops.stackexchange.com/questions/2089/what-are-the-advantages-of-dockerizing-nginx-and-php-in-different-containers

# php-fpm for admin host - phpMyAdmin and phpRedisAdmin

ARG version

FROM php:${version}
MAINTAINER Andrew Yeung <andrew@compandsave.com>

LABEL app.name="php-fpm"
LABEL app.version="${version}"

RUN apk update --no-cache

# Install dependencies with set -ex; - exits as soon as any line in the bash script fails with print on each command at screen
# --virtual - to build as virutal packages - https://github.com/gliderlabs/docker-alpine/blob/master/docs/usage.md
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
#  apk add --virtual .phpmyadmin-phpexts-rundeps $runDeps; \
  apk del .build-deps

COPY www.conf /usr/local/etc/php-fpm.d/
COPY php.ini /usr/local/etc/php/
COPY php-fpm.conf /usr/local/etc/

RUN addgroup -g 3000 app \
 && adduser -D -G app -u 3000 -H app

ENV html_volume=/var/www/html

USER app

VOLUME ${html_volume}
