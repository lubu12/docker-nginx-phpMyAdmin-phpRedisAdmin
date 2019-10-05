# Nginx (alpine) + PHP-FPM Docker

Run Nginx (alpine) and PHP-FPM via docker-compose
Tested at EC2 - Amazon Linux 2

## Set up environment variables at .env file
* `NGINX_VERSION` - Nginx alpine docker image tag, e.g., `mainline-alpine`
* `NGINX_PORT` - Default port 80
* `DOCKER_NGINX_PORT` - Default port 8080
* `PHP_FPM_VERSION` - PHP-FPM docker image tag, e.g., `7.3-fpm-alpine`
* `HTML_VOLUME` - Full path of the html root for nginx. Default value is `/var/www/html`

## Build and run with docker-compose
```
docker-compose up -d
```
