FROM ubuntu:latest

#[INFO] Install and configure packages
RUN apt-get update -y && apt-get install apt-utils -y && apt-get full-upgrade -y
RUN apt-get update -y && apt-get install software-properties-common -y
RUN apt-get install nginx -y

#[INFO] Copy nginx files and symlink
ADD index.html /var/www/nginx/
ADD nginx.conf /etc/nginx/
#[TESTS - INFO] Linting nginx.conf
RUN nginx -t

CMD ["nginx" "-g" "daemon off;"]