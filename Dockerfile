FROM ubuntu:latest

RUN apt-get update & apt-get full-upgrade -y
RUN apt-get install nginx -y

COPY index.html /var/www/nginx/index.html

CMD ["nginx","-g daemon off;"]