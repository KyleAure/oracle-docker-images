# Oracle Docker Images

This repo provides a script to automate the process of creating a prebuilt oracle docker image.

## Licensing

Oracle offers their own database container image [gvenzl/oracle-xe](https://hub.docker.com/r/gvenzl/oracle-xe) under the [Apache 2.0 License](https://github.com/gvenzl/oci-oracle-xe/blob/main/LICENSE)

## Decompressed Database
The oracle container image `gvenzl/oracle-xe` decompresses the database and configuration files at container runtime. 
This results in a long startup time for these containers. 

The script in this prepository automates the creation of a container that has already decompressed the database. 
This results in significally better runtime performance.

## Building image from source
Clone this repo, navigate to the source directory and run the `prebuild.sh` script.

```sh
git clone git@github.com:KyleAure/oracle-docker-images.git
cd oracle-docker-images/version2/src
./prebuild.sh
```

This script will do the following:
1. Build the base image `oracle/database:18.4.0-slim-expanded`
2. Make necessary edits to the `container-entrypoint.sh`
3. Run a `preconfigure.sh` script to decompress the database
4. Tag the base image
5. Clean up the intermediary containers, and dangling containers.

## Pull from dockerhub
```sh
docker pull kyleaure/oracle-18.4.0-slim-expanded
```

## Publishing to dockerhub
To push this image to a **private** dockerhub repository.

Create a private repository named:
```txt
<dockerhub-username>/oracle-18.4.0-xe-prebuilt
```
Then run the `prebuild.sh` script with the push parameter.
```sh
# version is typically 1.0 or latest
./prebuild.sh -p -u <dockerhub-username> -v <dockerhub-version>
```

