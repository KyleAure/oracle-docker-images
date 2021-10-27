Oracle Database 18c (version 18.4.0)
============================

>⚠️ Test container not for production use

>📣 Built on top of https://hub.docker.com/r/gvenzl/oracle-xe, but already has the database uncompressed to improve performance.

>📝 Supports all the same functions as `gvenzl/oracle-xe`

## Build from source
Script to build image is available on GitHub at: https://github.com/KyleAure/oracle-docker-images 

Run the following commands to build image locally:
```sh
git clone git@github.com:KyleAure/oracle-docker-images.git
cd oracle-docker-images/src
./prebuildv2.sh
```

The resulting image name will be `oracle/database:18.4.0-slim-expanded`

## Pull from dockerhub
```sh
docker pull kyleaure/oracle-18.4.0-slim-expanded
```

## Quick Start

Run with port 1521 (database) open.
```sh
#From source
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<yourPassword> oracle/database:oracle-18.4.0-slim-expanded
docker run -d -p 1521:1521 -e ORACLE_RANDOM_PASSWORD=yes oracle/database:oracle-18.4.0-slim-expanded

#From dockerhub
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<yourPassword> kyleaure/oracle-18.4.0-slim-expanded
docker run -d -p 1521:1521 -e ORACLE_RANDOM_PASSWORD=yes kyleaure/oracle-18.4.0-slim-expanded
```

Expected output (SAMPLE):
```txt
CONTAINER: starting up...
CONTAINER: database already initialized.
CONTAINER: starting up Oracle Database...

############################################
ORACLE PASSWORD FOR SYS AND SYSTEM: <RANDOM_PASSWORD>
############################################

#########################
DATABASE IS READY TO USE!
#########################
```

## Connecting to database

### General Information

```txt
hostname: localhost
port: 1521
sid: xe
service name: XE
pdb service name: XEPDB1
```

### SQLPlus (Local)
Connect to database using SQLPlus on your local system:
```sh
sqlplus sys/<yourPassword>@//localhost:1521/XE as sysdba
sqlplus system/<yourPassword>@//localhost:1521/XE
sqlplus pdbadmin/<yourPassword>@//localhost:1521/XEPDB1
```

### SQLPlus (Container)
Connect to database using SQLPlus from inside the database container:
```sh
docker exec -it --user oracle <container-name> /bin/sh -c 'sqlplus / as sysdba'
docker exec -it --user oracle <container-name> /bin/sh -c 'sqlplus system/<yourPassword>'
docker exec -it --user oracle <container-name> /bin/sh -c 'sqlplus pdbadmin@XEPDB1/<yourPassword>'
```

### JDBC URLs
Use these URLs to connect to the database using a current JDBC driver
```URL
jdbc:oracle:thin:system/<yourPassword>@//localhost:1521:XE
jdbc:oracle:thin:system/<yourPassword>@//localhost:1521/XE
jdbc:oracle:thin:system/<yourPassword>@//localhost:1521/XEPDB1
```

## Extend image
Support custom DB Initialization and running shell scripts
```Dockerfile
# Dockerfile
FROM kyleaure/oracle-18.4.0-slim-expanded

ADD init.sql /opt/oracle/scripts/startup
ADD script.sh /opt/oracle/scripts/startup
```
Running order is alphabetically. 