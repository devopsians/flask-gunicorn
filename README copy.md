##### Flask Gunicorn ref: https://www.golinuxcloud.com/flask-gunicorn-nginx/#####

#Step-1: Install pre-requisite packages

python3 --version
#Python 3.8.10

sudo apt update

#sudo apt install python3.9

pip3 --version
#pip 20.3.4 from /usr/lib/python3.9/site-packages/pip (python 3.9)

#sudo apt install python-pip

#Step-2: Create Python Virtual Environment

#apt install python3.8-venv

python3 -m venv menv

source ./menv/bin/activate

#Step-3: Install flask and gunicorn packages

pip3 install flask gunicorn

#Step-4: Setup Flask API/Web Application

######

#Step-5: Configure Gunicorn

#5.1: Create WSGi Entry Point

################

from my_app import app

if __name__ == "__main__":
	app.run()
################

#5.2: Access Flask web app using Gunicorn

gunicorn -w 4 --bind 0.0.0.0:8000 wsgi:app

#5.3: Use Gunicorn as systemd service

deactivate # this deactivates the temprorary environment we created

sudo vi /etc/systemd/system/flask-gunicorn.service

################

[Unit]
Description=Flask API/Web Application Server using Gunicorn
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/projects/python/flask-gunicorn
Environment="PATH=/home/ubuntu/projects/python/flask-gunicorn/menv/bin"
ExecStart=/bin/bash -c 'source /home/ubuntu/projects/python/flask-gunicorn/menv/bin/activate; gunicorn -w 3 --bind unix:/home/ubuntu/projects/python/flask-gunicorn/ipc.sock wsgi:app'
Restart=always

[Install]
WantedBy=multi-user.target

################


sudo mkdir /tmp/flask-gunicorn

sudo chmod ubuntu:ubuntu /tmp/flask-gunicorn

sudo systemctl enable flask-gunicorn.service --now

systemctl status flask-gunicorn.service

sudo systemctl restart flask-gunicorn.service


sudo systemctl stop flask-gunicorn

## Check logs

journalctl -u flask-gunicorn.service -f

### Remove service from Systemd ###

sudo systemctl stop flask-gunicorn.service
sudo systemctl disable flask-gunicorn.service
sudo rm /etc/systemd/system/flask-gunicorn.service
sudo rm /etc/systemd/system/multi-user.target.wants/flask-gunicorn.service # and symlinks that might be related
sudo rm /usr/lib/systemd/system/flask-gunicorn.service 
sudo rm /usr/lib/systemd/system/multi-user.target.wants/flask-gunicorn.service # and symlinks that might be related
sudo systemctl daemon-reload
sudo systemctl reset-failed

####################################

#Step-6: Configuring Nginx

#6.1: Install nginx package

sudo apt install nginx

cd /etc/nginx/

sudo vi sites-available/flask-gunicorn

###
server {
    listen 80;

    location / {
        include proxy_params;
        proxy_pass http://unix:/home/ubuntu/projects/python/flask-gunicorn/ipc.sock;
    }
}
###

#Next run the sudo nginx -t to make sure that the syntax of the configuration file is ok,

sudo nginx -t

#Once the syntax check passes, create a symbolic link of this file into sites-enabled directory:

sudo ln -s /etc/nginx/sites-available/flask-gunicorn /etc/nginx/sites-enabled/

sudo ls -l  /etc/nginx/sites-enabled/

sudo nginx -s reload

#6.3: Verify nginx proxy request

#If you visited your IP address http://your-ip-address you will get a respond.