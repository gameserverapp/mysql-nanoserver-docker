# MySQL 5.7 Windows Servercore Container

**Linux and Bash?**

**No, thanks!**

**Windows® and Powershell®**

`docker pull dshatohin/mysql-nanoserver:latest`

[`5.7-1903 , latest` (*Dockerfile*)](https://github.com/dshatohin/mysql-nanoserver-docker/blob/master/mysql-nanoserver_5.7-1903/Dockerfile)

[`5.7-1809` (*Dockerfile*)](https://github.com/dshatohin/mysql-nanoserver-docker/blob/master/mysql-nanoserver_5.7-1809/Dockerfile)

# About this image
Production ready Windows container with MySQL. Also very useful for testing purposes.

# How to use this image?
Starting a MySQL instance is simple:

`docker run --name mysql-db -e MYSQL_ROOT_PWD=password -d dshatohin/mysql-nanoserver:latest`

 - `mysql-db` - name of your container
 - `password` - your sercret password

You also can start container and create database:

`docker run --name mysql-db -e MYSQL_ROOT_PWD=password -e DB_NAME=database -e DB_USER=dbuser -e DB_USER_PWD=userpassword -d dshatohin/mysql-nanoserver:latest`

 - `mysql-db` - name of your container
 - `-e MYSQL_ROOT_PWD=password` - your sercret password
 - `-e DB_NAME=database` - name of your database
 - `-e DB_USER=dbuser` - name of your user
 - `-e DB_USER_PWD=userpassword` - your sercret password for `dbuser`

Parameters `DB_NAME`, `DB_USER` and `DB_USER_PWD` is working only if you set all of them `¯\_(ツ)_/¯`

# Connect to MySQL with Adminer via docker [`stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy)
Example `stack.yml` for `mysql-nanoserver`:
```
# Use root/example as user/password credentials
version: '3.1'

services:

  db:
    image: dshatohin/mysql-nanoserver:latest
    ports:
      - 3306:3306
    environment:
      MYSQL_ROOT_PWD: password

  adminer:
    image: dshatohin/adminer-iis:latest
    ports:
      - 8000:80
```
Run `docker stack deploy -c stack.yml mysql` and visit `http://swarm-ip:8000`, `http://localhost:8000` or `http://host-ip:8000`
