Oracle Database 18c (version 18.4.0)
============================

>⚠️ Test container not for production use

>📣 Built on top of https://hub.docker.com/r/gvenzl/oracle-xe, but already has the database uncompressed to improve performance.

>📝 Supports all the same functions as `gvenzl/oracle-xe`

## Build from source
Script to build image is available on GitHub at: https://github.com/KyleAure/oracle-docker-images 

## Image versions available
| version | original size | expanded size | description |
| ---: | :---: | :---: | --- |
|[1.0.slim](https://github.com/KyleAure/oracle-docker-images/blob/master/version2/src/config/18.4.0-slim.Dockerfile)| 1.97GB | 4.11GB |from gvenzl/oracle-xe:18.4.0-slim |
|[1.0, latest](https://github.com/KyleAure/oracle-docker-images/blob/master/version2/src/config/18.4.0.Dockerfile)| 2.91GB | 5.09GB | from gvenzl/oracle-xe:18.4.0 |
|[1.0.full](https://github.com/KyleAure/oracle-docker-images/blob/master/version2/src/config/18.4.0-full.Dockerfile)| 6.38GB | 9.19GB |from gvenzl/oracle-xe:18.4.0-full |
|[1.0.full.ssl](https://github.com/OpenLiberty/open-liberty/blob/release/dev/com.ibm.ws.jdbc_fat_oracle/publish/files/oracle-ssl/Dockerfile)| N/A | 9.63GB | extends 1.0.full and has ssl preconfigured |
|[1.0.full.krb5](https://github.com/OpenLiberty/open-liberty/blob/release/dev/com.ibm.ws.jdbc_fat_krb5/publish/files/oracle/Dockerfile)| N/A | 9.88GB | extends 1.0.full and has krb5 preconfigured |

## Quick Start [1.0.slim, 1.0, 1.0.full]

Pull from dockerhub
```sh
docker pull kyleaure/oracle-18.4.0-expanded:1.0.slim
```

Run with port 1521 (database) open.
```sh
docker run -d -p 1521:1521 -e ORACLE_PASSWORD=<yourPassword> kyleaure/oracle-18.4.0-expanded:1.0.slim
docker run -d -p 1521:1521 -e ORACLE_RANDOM_PASSWORD=yes kyleaure/oracle-18.4.0-expanded:1.0.slim
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

## Quick Start [1.0.full.ssl]

Pull from dockerhub
```sh
docker pull kyleaure/oracle-18.4.0-expanded:1.0.full.ssl
```

Run with ports 1521 (tcp database) and 1522 (tcps database) open.
```sh
docker run -d -p 1521:1521 -p 1522:1522 -e ORACLE_PASSWORD=<yourPassword> kyleaure/oracle-18.4.0-expanded:1.0.full.ssl
docker run -d -p 1521:1521 -p 1522:1522 -e ORACLE_RANDOM_PASSWORD=yes kyleaure/oracle-18.4.0-expanded:1.0.full.ssl
```

Expected output (SAMPLE):
```txt
CONTAINER: starting up...
CONTAINER: database already initialized.
CONTAINER: starting up Oracle Database...

TNSLSNR for Linux: Version 18.0.0.0.0 - Production
System parameter file is /opt/oracle/product/18c/dbhomeXE/network/admin/listener.ora
Log messages written to /opt/oracle/diag/tnslsnr/441139d48dab/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcps)(HOST=0.0.0.0)(PORT=1522)))

############################################
ORACLE PASSWORD FOR SYS AND SYSTEM: <RANDOM_PASSWORD>
############################################

CONTAINER: Executing user defined scripts...
CONTAINER: running /container-entrypoint-startdb.d/startup.sql ...

Session altered.
User created.
Grant succeeded.

CONTAINER: DONE: running /container-entrypoint-startdb.d/startup.sql
CONTAINER: DONE: Executing user defined scripts.

#########################
DATABASE IS READY TO USE!
#########################
```

## Quick Start [1.0.full.krb5]

Pull from dockerhub
```sh
docker pull kyleaure/oracle-18.4.0-expanded:1.0.full.krb5
```

Run with ports 1521 (tcp database) and 1522 (tcps database) open.
```sh
docker run -d -p 1521:1521 -p 1522:1522 -e ORACLE_PASSWORD=<yourPassword> kyleaure/oracle-18.4.0-expanded:1.0.full.krb5
docker run -d -p 1521:1521 -p 1522:1522 -e ORACLE_RANDOM_PASSWORD=yes kyleaure/oracle-18.4.0-expanded:1.0.full.krb5
```

Expected output (SAMPLE):
```txt
CONTAINER: starting up...
CONTAINER: database already initialized.
CONTAINER: starting up Oracle Database...

############################################
ORACLE PASSWORD FOR SYS AND SYSTEM: <RANDOM_PASSWORD>
############################################

CONTAINER: Executing user defined scripts...
CONTAINER: running /container-entrypoint-startdb.d/01_kerberos.sh ...

Username: oracle
Initialize oracle user(s)
  Kerberos Utilities for Linux: Version 18.0.0.0.0 - Production on 15-DEC-2021 05:55:21
  Copyright (c) 1996, 2018 Oracle.  All rights reserved.
  Password for ORACLEUSR@EXAMPLE.COM:
  okinit: Cannot find KDC for requested realm

List principles in key table:
  Kerberos Utilities for Linux: Version 18.0.0.0.0 - Production on 15-DEC-2021 05:55:21
  Copyright (c) 1996, 2018 Oracle.  All rights reserved.
  Configuration file : /etc/krb5.conf.
  Keytab name: FILE:/etc/krb5.keytab
  KVNO Timestamp         Principal
  ---- ----------------- --------------------------------------------------------
   1 12/15/21 05:54:27 XE/oracle@EXAMPLE.COM
   1 12/15/21 05:54:27 oracle@EXAMPLE.COM

Make credential cache accessible

CONTAINER: DONE: running /container-entrypoint-startdb.d/01_kerberos.sh
CONTAINER: running /container-entrypoint-startdb.d/02_oracle.sql ...

Session altered.
User created.
Grant succeeded.
Grant succeeded.

CONTAINER: DONE: running /container-entrypoint-startdb.d/02_oracle.sql
CONTAINER: DONE: Executing user defined scripts.
#########################
DATABASE IS READY TO USE!
#########################
```

## Connecting to database

### General Information

```properties
hostname: localhost
port: 1521(TCP/IP) 1522 (TCPS)
sid: xe
service name: xe
pdb service name: <configurable> (default is XEPDB1)
dba User: system
app User: <configurable>
password: <configurable> (default is random)
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
Support custom DB initialization and running shell scripts

```Dockerfile
# Dockerfile
FROM kyleaure/oracle-18.4.0-expanded:1.0.slim

ADD init.sql /container-entrypoint-initdb.d/
ADD script.sh /container-entrypoint-startdb.d/
```
Running order is alphabetically.