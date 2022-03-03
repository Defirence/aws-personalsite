FROM nginx:latest

COPY index.html /var/www/nginx/index.html

CMD ["nginx","-g daemon off;"]