# Nginx + phpMyAdmin + phpRedisAdmin (php-fpm) via Docker - Alpine

Run Nginx, phpMyAdmin and phpRedisAdmin (php-fpm) - Alpine via docker-compose
Tested at AWS EC2 and RDS - Amazon Linux 2

Docker Reference: https://github.com/phpmyadmin/docker

Docker Reference: https://github.com/erikdubbelboer/phpRedisAdmin


## Description
3 Docker containers: phpMyAdmin and phpRedisAdmin will share the same nginx container.

phpMyAdmin <-> Nginx <-> phpRedisAdmin

phpMyAdmin and phpRedisAdmin containers are separated.  They are using different network interfaces to talk to nginx.  All 3 containers are using the shared html document root, /var/www/html/.  phpMyAdmin is under /var/www/html/phpMyAdmin/, and phpRedisAdmin is under /var/www/html/phpRedisAdmin/. The php-fpm port for phpMyAdmin is changed to 9001 while phpRedisAdmin is using the default port 9000.  It is not necessary to use different ports for 2 isolated php-fpm containers.  Reference: https://github.com/docker-library/php/issues/479

This solution is to run 2 isolate php-fpm containers in different directories, and there is another solution for running isolated containers in 2 different server blocks. Reference: https://dev.to/johnmccuk/isolating-php-with-docker-containers-4epn


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

# php-fpm configuration for phpMyAdmin
phpmyadmin/php-fpm.conf
phpmyadmin/php.ini
phpmyadmin/www.conf

# php-fpm configuration for phpRedisAdmin
phpredisadmin/php-fpm.conf
phpredisadmin/php.ini
phpredisadmin/www.conf
```


## Create config.inc.php under phpredisadmin/ - phpRedisAdmin configuration file
`touch phpredisadmin/config.inc.php`

Sample file can be obtained from https://github.com/erikdubbelboer/phpRedisAdmin/blob/master/includes/config.sample.inc.php


## Add the executable permission to docker-entrypoint.sh to fix the permission denied issue
```
chmod +x phpmyadmin/docker-entrypoint.sh
chmod +x phpredisadmin/docker-entrypoint.sh
```
Reference: https://github.com/composer/docker/issues/7


## Make sure phpMyAdmin and phpRedisAdmin directores do not exist under /var/www/html/
Our phpmyadmin/docker-entrypoint.sh and phpredisadmin/docker-entrypoint.sh will automatically create phpMyAdmin and phpRedisAdmin directories under /var/www/html/. It may cause unexpected issue if phpMyAdmin or phpRedisAdmin exists.


## Build and run with docker-compose
```
docker-compose up -d
```


## Rebuild the docker image after nginx or php-fpm configuration file is changed
```
docker-compose down
docker-compose up --build -d
```
