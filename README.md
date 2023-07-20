# Oracle Docker Images

This repo provides three ways to automate the process of creating a prebuilt oracle docker image.

# Version 1
Link: [18.4.0 From Oracle Installer](https://github.com/KyleAure/oracle-docker-images/blob/master/18.4.0-from-installer/README.md)

This method was originally published by oracle and released under their Universal Permissive License.
The edits I made to this method was to pre-build the oracle database to improve performance at container runtime.

This container image is no longer published due to log4j vulnerabilities.

# Version 2
Link: [18.4.0 From Oracle Image](https://github.com/KyleAure/oracle-docker-images/blob/master/18.4.0-from-image/README.md)

This method involves expanding on the existing https://hub.docker.com/r/gvenzl/oracle-xe image released under the Apache 2.0 License.
The edits I made to this method was to decompress the oracle database to improve performance at container runtime.

This container is published at: https://hub.docker.com/r/kyleaure/oracle-18.4.0-slim-expanded

# Version 3
Link: [21.3.0 From Oracle Image](https://github.com/KyleAure/oracle-docker-images/blob/master/21.3.0-from-image/README.md)

This method involves expanding on the existing https://hub.docker.com/r/gvenzl/oracle-xe *faststart* image released under the Apache 2.0 License.
The only edits I made to these images is to remove potentially vulnerable log4j binaries 

This container is published at: https://hub.docker.com/r/kyleaure/oracle-18.4.0-slim-expanded