FROM ubuntu:latest

RUN echo "[INFO] Install and configure packages"
RUN apt-get update -y && apt-get full-upgrade -y && apt-get install ufw nginx python3-certbot-nginx fail2ban -y

RUN echo "[INFO] Enabling ufw and allowing Port 22"
RUN ufw enable
RUN ufw allow ssh
RUN ufw allow 22/tcp
RUN ufw app list && sleep 2
RUN ufw allow 'Nginx Full'
RUN ufw status
RUN systemctl status nginx
RUN mkdir -p /var/www/defirence.mooo.com/html
RUN chown -R $USER:$USER /var/www/defirence.mooo.com/html && chmod -R 755 /var/www/defirence.mooo.com

RUN echo "[TEST - INFO] Linting nginx.conf"
RUN nginx -t /etc/nginx/nginx.conf

RUN echo "[INFO] Copy nginx files and symlink"
ADD index.html /var/www/nginx/
ADD nginx.conf /etc/nginx/
RUN ln -s /etc/nginx/sites-available/defirence.mooo.com /etc/nginx/sites-enabled/

RUN echo "[INFO] Enable and configure fail2ban for nginx + sshd"
RUN cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
ADD sshd.local /etc/fail2ban/jail.d/
ADD nginx-block.local /etc/fail2ban/jail.d/

RUN systemctl restart fail2ban
RUN iptables -L -n && sleep 2
RUN echo "[INFO] Checking fail2ban status"
RUN fail2ban-client status sshd nginx-block

RUN "[INFO] Restart nginx and check status"
RUN systemctl restart nginx && sleep 1
RUN systemctl status nginx

RUN "[INFO] Running certbot dry run for domain"
RUN certbot --nginx -d defirence.mooo.com -d www.defirence.mooo.com

RUN echo "[INFO] Verifying certbot automatic renewal"
RUN systemctl status certbot.timer
RUN certbot renew --dry-run

CMD ["nginx" "-g" "daemon off;"]