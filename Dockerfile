FROM nginx:latest

ADD index.html /var/www/nginx/index.html
ADD nginx.conf /etc/nginx/nginx.conf
RUN nginx -t

CMD ["nginx","-g daemon off;"]
EXPOSE 80