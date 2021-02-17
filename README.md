# Docker Images for Cassandra (CentOS and Alpine)

This is a simple example on how to create images / docker containers using .env and docker-compose files for Cassandra in CentOS and Alpine.

Just to illustrate how to use the docker compose and .env, I create 2 types of base, base_centos and base_alpine images and using them, I create cassandra.v3_0.configure images

The versions of Cassandra to be used as well as the versions (tags) of the images are configured in the .env file.

The structure of folders and files must be as follows:

```
.
├── base_alpine
│   └── dockerfile
├── base_centos
│   └── dockerfile
├── cassandra_alpine
│   ├── docker-entrypoint.sh
│   └── dockerfile
├── cassandra_centos
│   ├── docker-entrypoint.sh
│   └── dockerfile
├── .env
└── docker-compose.yaml

```

The values of the variables used to create the images are in the .env file:

```
# All
MAINTAINER="fausto.branco"

# base_centos
BASE_CENTOS_VERSION=3.1
FROM_CENTOS_IMAGE=centos
FROM_CENTOS_TAG=7

# base_alpine
BASE_ALPINE_VERSION=3.1
FROM_ALPINE_IMAGE=alpine
FROM_ALPINE_TAG=latest

# cassandra_centos
CASSANDRA_CENTOS_HOME=/etc/cassandra
CASSANDRA_CENTOS_VERSION=3.11.10

# cassandra_alpine
CASSANDRA_ALPINE_HOME=/root/cassandra
CASSANDRA_ALPINE_VERSION=3.11.10
```



The versions / tags of the cassandra images, use the same value as the environment variables: CASSANDRA_XXXXXX_VERSION



### Create Base Images

------

To create the base and cassandra images in CentoOS, at the root of the structure, do the build:

```
docker-compose build --no-cache --force-rm base_centos

docker-compose build --no-cache --force-rm cassandra_centos
```



To create the base and cassandra images in Alpine, at the root of the structure, do the build:

```
docker-compose build --no-cache --force-rm base_alpine

docker-compose build --no-cache --force-rm cassandra_alpine
```



### Create Containers:

------

##### To create the Cassandra container in CentOS using the image generated above:

```
docker container run -d --name cassandra-centos1 -p7000:7000 -p7001:7001 -p9042:9042 -p9160:9160 -e CASSANDRA_CLUSTER_NAME="cluster_centos_teste"  -d cassandra_centos:3.11.10

```

To access the container shell:

```
docker container exec -it cassandra-centos1 /bin/bash
```

To stop and remove the container: 

```
docker container stop cassandra-centos1
docker container rm cassandra-centos1
```



##### To create the Cassandra container in Alpine using the image generated above:

```
docker container run -it -d --name cassandra-alpine1 -p7000:7000 -p7001:7001 -p9042:9042 -p9160:9160 -e CASSANDRA_CLUSTER_NAME="cluster_alpine_teste" -d cassandra_alpine:3.11.10

```

To access the container shell: 

```
docker container exec -it cassandra-alpine1 /bin/sh
```

To stop and remove the container: 

```
docker container stop cassandra-alpine1
docker container rm cassandra-alpine1
```



### Informations

------

At the end, follow the information about the size of the CentOS x Alpine images

```
[root@srv-docker work]# docker images
REPOSITORY         TAG       IMAGE ID       CREATED          SIZE
base_alpine        3.1       17edc9c03535   9 minutes ago    177MB
cassandra_alpine   3.11.10   6f6b355855b4   3 minutes ago    319MB
base_centos        3.1       0a042b8f168f   45 minutes ago   313MB
cassandra_centos   3.11.10   4a185b35404c   17 minutes ago   743MB
```


