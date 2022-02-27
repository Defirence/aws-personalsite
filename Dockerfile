FROM ubuntu:latest

RUN /bin/bash ./local-sources.sh
RUN sleep 5

RUN echo "[INFO] Install and configure packages"
RUN apt-get update -y && apt-get full-upgrade -y && apt-get install apt-utils -y
RUN apt-get update && apt install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install nginx python3.9 python3-certbot-nginx fail2ban -y

RUN echo "[INFO]: Verify Python 3.9 is installed"
RUN python3.9 --version

RUN echo "[INFO] Checking nginx status and running mkdir"
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

################################
#Commenting this out on dev branch to prevent
#accidental (and unwanted) registration conflicts.
#RUN "[INFO] Running certbot registration"
#RUN certbot --nginx -d defirence.mooo.com -d www.defirence.mooo.com
################################

RUN echo "[INFO] Verifying certbot automatic renewal"
RUN systemctl status certbot.timer
RUN certbot renew --dry-run

CMD ["nginx" "-g" "daemon off;"]