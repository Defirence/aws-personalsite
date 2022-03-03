FROM ubuntu:latest

EXPOSE 80/tcp

RUN apt-get update -y && apt-get install apt-utils -y && apt-get full-upgrade -y
RUN apt-get update -y && apt-get install software-properties-common -y
RUN apt-get install nginx -y

ADD index.html /var/www/nginx/
ADD nginx.conf /etc/nginx/

RUN nginx -t

CMD nginx -g daemon off