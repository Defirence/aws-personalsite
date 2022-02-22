# aws-personalsite
A small static website that uses Docker+nginx, EC2 and Afraid.org DNS

## USAGE:

##### Run and bind $HOME to target=/path/to/html/ for Docker nginx.

`sudo docker container run -d --name test-nginx --mount type=bind,source=/home/ubuntu/,target=/var/www/html/ -p 80:80 nginx_site:0.1`

## TODO:

* crontab (automation) for FreeDNS script - Semi-complete, considering doing this with Terraform :white_check_mark:
* Logging - EFK Stack - Priority :zap:
* Grafana - Priority :zap:
* Actual Site Content(SoonTM) - Low priority :arrow_down:
* StartTree - Low priority :arrow_down:
* index.html and CSS to handle `font-family` tags instead of letting each tag use it individually. - Basic Implementation Done :white_check_mark:
* Gitea - Low priority :arrow_down:
* Document the method to add emoji unicode to the <title> tag - Low priority :arrow_down:
* Rewrite the Dockerfile - Priority :zap: :arrow_forward: In Progress

## Caveats:

* Exposing EC2 Port 80 for testing to 0.0.0.0/0 ::0 allows brute-force GET/POST attacks looking for unpatched 0-Day exploits.
* If a suspected breach has occured on the EC2 instance, nuke .ssh/* on the compromised host, immediately close off ports on AWS Console from internet, invalidate the dirty SSH keys and terminate the instance ASAP.
* Recreating an EC2 testing instance takes long, requires doing a full-upgrade and apt-get upgrade, and then installing Docker. Look into cutting down time with Terraform and ArgoCD.

## Changes:

* 0.1 - Initial Commit. Created Dockerfile. Broke the html in vim when trying to test docker volume bind mounts.
* 0.2 - Security hardening, nginx config rebuilt from the ground up to mitigate brute force attacks via HTTP/S.
    - Enabled Snyk container image scanning and GitHub workflows.