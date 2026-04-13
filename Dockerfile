# syntax=docker/dockerfile:1.19
FROM nginx:alpine AS base

COPY --exclude=pictures . /usr/share/nginx/html/
COPY .docker/nginx-vhost.conf /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=1m --timeout=10s \
	CMD nc -z localhost 80

VOLUME ["/images"]


FROM base AS external-pictures


FROM base AS bundled-pictures
COPY pictures/ /usr/share/nginx/html/pictures/
