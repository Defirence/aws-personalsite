FROM ubuntu:latest

#[INFO] Install and configure packages
RUN apt-get update -y && apt-get install apt-utils -y && apt-get full-upgrade -y
RUN apt-get update -y && apt-get install software-properties-common -y && apt-get install curl -y
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install nginx python3.9 python3-certbot-nginx fail2ban -y

#[INFO]: Add local sources
ADD local-sources.sh /
RUN /bin/bash /local-sources.sh
RUN sleep 5

#[INFO]: Verify Python 3.9 is installed
RUN python3.9 --version

#[INFO] Running mkdir for nginx directories
RUN mkdir -p /var/www/defirence.mooo.com/html
RUN chown -R $USER:$USER /var/www/defirence.mooo.com/html && chmod -R 755 /var/www/defirence.mooo.com

#[INFO] Copy nginx files and symlink
ADD index.html /var/www/nginx/
ADD nginx.conf /etc/nginx/
RUN ln -s /etc/nginx/sites-available/defirence.mooo.com /etc/nginx/sites-enabled/
#[TESTS - INFO] Linting nginx.conf
RUN nginx -t

#[INFO] Enable and configure fail2ban for nginx + sshd
RUN cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
ADD sshd.local /etc/fail2ban/jail.d/
ADD nginx-block.local /etc/fail2ban/jail.d/
RUN service fail2ban restart
RUN iptables -L -n && sleep 2

#[INFO] Checking fail2ban status
RUN fail2ban-client status sshd nginx-block

#[INFO] Restart nginx and check status
RUN service nginx restart && sleep 1
RUN service nginx status

################################
#Commenting this out on dev branch to prevent
#accidental (and unwanted) registration conflicts.
#[INFO] Running certbot registration
#RUN certbot --nginx -d defirence.mooo.com -d www.defirence.mooo.com
################################

#[INFO] Verifying certbot automatic renewal
RUN service certbot status
RUN certbot renew --dry-run

CMD ["nginx" "-g" "daemon off;"]