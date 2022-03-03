FROM nginx:latest

ADD index.html /var/www/nginx/
ADD nginx.conf /etc/nginx/

RUN nginx -t

EXPOSE 80
CMD ["nginx","-g daemon off;"]