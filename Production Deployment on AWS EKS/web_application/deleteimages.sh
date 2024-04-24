#! /bin/bash

docker stop application mysql-db
docker rm application mysql-db
docker rmi application:v0.1 database:v0.1
docker network rm group1Bridge
#wrostcase if need remove another unusiamge
# docker image prune -a -f