# flask-gunicor

python3 -m venv menv

source menv/bin/activate

pip3 install -r requirements.txt

deactivate

#sudo systemctl restart flask-gunicorn.service 

sudo systemctl status flask-gunicorn.service 