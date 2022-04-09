# flask-gunicorn

Replace IP in nginx

sudo sed -i s/3.6.89.210/3.109.62.203/g  /etc/nginx/sites-available/flask-gunicorn

sudo systemctl restart nginx.service 

####

sudo chown -R ubuntu:ubuntu /home/ubuntu/projects-git/*

python3 -m venv menv

source menv/bin/activate

pip3 install -r requirements.txt

deactivate

#sudo systemctl restart flask-gunicorn.service 

#sudo systemctl restart nginx.service 

sudo systemctl status flask-gunicorn.service 

## Run flask app using gunicorn
# gunicorn -w 4 -b 0.0.0.0:5000 wsgi:app
