#!/bin/bash

sudo docker system prune -af
sudo docker container stop $(sudo docker container ls -aq) -f
sudo docker container rm $(sudo docker container ls -aq) -f
sudo docker rmi $(sudo docker images -aq) -f
sudo docker volume prune -f