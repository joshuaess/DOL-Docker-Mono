# DOL-Docker-Mono
Docker compose file to quickly bring up a DAOC [Dawn of Light](https://github.com/Dawn-of-Light/DOLSharp) local development environment or production server running on [Docker](https://github.com/docker/docker).

## Instructions
#### Install Docker Community Edition (Docker CE) from [here](https://www.docker.com/community-edition#/download) or using your system's package manager
If you're running docker from OSX or Windows, I recommend changing the allotted cores that docker can use from 4 to 8 in **Preferences** -> **Advanced**. Prior to this change, I noticed some authentication/database timeout issues for container to container traffic

#### [Install Docker Compose](https://docs.docker.com/compose/install/)

#### Pull down this repo with git (or use the link to the zip on this page)
    git clone https://github.com/joshuaess/DOL-Docker-Mono.git
    
#### Edit the server configuration environment variables in .env
    cd DOL-Docker-Mono
* Windows -- open using cli or your gui editor of choice
    
      .env
* OSX/\*nix -- open using vim or editor of your choice

      open .env
      # or
      vim .env

#### Build our Docker images and bring up dol and mariadb containers in -d detached mode
    docker-compose up -d
You should now have a working dawn of light instance that you can connect to at localhost port 10300 (or the ip address of your server assuming that port 10300, 10400 are open on your server's firewall). Keep in mind that data from your database will persist to DOL-Docker-Mono/mariadb

## Troubleshooting
#### Check your container status ( you should see dol and mariadb)
	docker ps
example output:
```
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                                                NAMES
68095b004a29        dol:latest           "/dol-entrypoint.sh"     11 hours ago        Up 11 hours         0.0.0.0:10300->10300/tcp, 0.0.0.0:10400->10400/udp   mono_dol_1
21d53b55e0ac        dol_mariadb:latest   "/mariadb-entrypoi..."   11 hours ago        Up 11 hours         0.0.0.0:3306->3306/tcp                               mono_mariadb_1
```
#### Enter a shell on a container
	docker exec -ti 68095b004a29 bash
#### If the containers died, try running `docker-compose up` without the -d flag to attach to the shell output sessions of each both containers.
	docker-compose up
#### Take down your existing containers
	docker-compose down
#### Rebuild your images
	docker-compose up --build
#### Delete your database volume on the docker host
	# make sure that our containers are not running
	docker-compose down
    rm -Rfv DOL-Docker-Mono/mariadb
#### If you made changes to the dol source or scripts (back up your changes first)
	docker-compose down
    rm -Rfv DOL-Docker-Mono/dol
#### Alternatively, you can simply clone a fresh copy of this repo to a new directory and generate a new database/copy of dol codebase
	cd ~ # or whatever directory you want to keep your dol files in
    git clone https://github.com/joshuaess/DOL-Docker-Mono.git my_new_test_server
    cd my_new_test_server
    # configure your .env file
    docker-compose up -d
    
