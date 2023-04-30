FROM alpine:latest

RUN apk add --no-cache nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY sites-available /etc/nginx/sites-available
COPY sites-enabled /etc/nginx/sites-enabled

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]