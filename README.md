# Nginx + phpMyAdmin (php-fpm) via Docker - Alpine

Run Nginx and phpMyAdmin (php-fpm) - Alpine via docker-compose

Reference: https://github.com/phpmyadmin/docker

Tested at AWS EC2 and RDS - Amazon Linux 2

## Create environment variables at .env file at working directory
* `NGINX_VERSION` - Nginx (alpine) docker image tag, e.g., `mainline-alpine`
* `NGINX_PORT` - Default port 80
* `DOCKER_NGINX_PORT` - Default port 8080
* `PHP_FPM_VERSION` - PHP-FPM docker image tag, e.g., `7.3-fpm-alpine`
* `HTML_VOLUME` - Full path of the html root for nginx. Default value is `/var/www/html`
* `PMA_HOSTS` - Define comma separated list of address/host names of the MySQL servers
* `PMA_ABSOLUTE_URI` - Define user-facing URI. Our docker-entrypoint.sh will automatically create the phpMyAdmin directory under /var/www/html/. Please change that accordingly if you want to use other path.

Example:
```
NGINX_VERSION=mainline-alpine
NGINX_PORT=80
DOCKER_NGINX_PORT=8080
PHP_FPM_VERSION=7.3-fpm-alpine
HTML_VOLUME=/var/www/html
PMA_HOSTS=YOUR_DB_HOSTNAME(S)
PMA_ABSOLUTE_URI=YOUR_HOSTNAME/phpMyAdmin
```

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

## Add the executable permission to docker-entrypoint.sh to fix the permission denied issue
```
chmod +x phpmyadmin/docker-entrypoint.sh
```
Reference: https://github.com/composer/docker/issues/7

## Make sure phpMyAdmin directory does not exist under /var/www/html/
Our phpmyadmin/docker-entrypoint.sh will automatically create phpMyAdmin directory under /var/www/html/. It may cause unexpected issue if it exists.

## Build and run with docker-compose
```
docker-compose up -d
```

## Rebuild the docker image after nginx or php-fpm configuration file is changed
```
docker-compose down
docker-compose up --build -d
```
