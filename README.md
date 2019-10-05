# Nginx (alpine) + PHP-FPM Docker

Run Nginx (alpine) and PHP-FPM via docker-compose
Tested at EC2 - Amazon Linux 2

## Set up environment variables at .env file
* `NGINX_VERSION` - Nginx (alpine) docker image tag, e.g., `mainline-alpine`
* `NGINX_PORT` - Default port 80
* `DOCKER_NGINX_PORT` - Default port 8080
* `PHP_FPM_VERSION` - PHP-FPM docker image tag, e.g., `7.3-fpm-alpine`
* `HTML_VOLUME` - Full path of the html root for nginx. Default value is `/var/www/html`

## Create new user and group
The new user and group will be running the nginx and php-fpm instances. UID and GID for `app:app` are 3000.

Example at EC2 - Amazon Linux 2
```
sudo groupadd -g 3000 app
sudo useradd -s /sbin/nologin -g 3000 -u 3000 app
```

## Configure nginx.conf and php-fpm configuration files
```
nginx/nginx.conf
php-fpm/php-fpm.conf
php-fpm/php.ini
php-fpm/www.conf
```

## Build and run with docker-compose
```
docker-compose up -d
```

## Rebuild the docker image after nginx or php-fpm configuration file is changed
```
docker-compose down
docker-compose build
```
