# Dockerfile Best Practice - https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

# Nginx version is passed via ARG from docker-compose
ARG version

FROM nginx:${version}
MAINTAINER Andrew Yeung <andrew@compandsave.com>

ARG version
ARG html_volume

LABEL app.name="nginx"
LABEL app.version="${version}"

RUN apk update --no-cache

COPY nginx.conf /etc/nginx/nginx.conf

# Use ~ instead of / as the delimiter for sed since html_root is having / character
RUN sed -i "s~HTML_ROOT~${html_volume}~g" /etc/nginx/nginx.conf
 
# Run as non-root - http://pjdietz.com/2016/08/28/nginx-in-docker-without-root.html
RUN addgroup -g 3000 app \
 && adduser -D -G app -u 3000 -H app \
 && touch /var/run/nginx.pid \
 && chown -R app:app /var/run/nginx.pid \
 && chown -R app:app /var/cache/nginx

USER app

VOLUME ${html_volume}
