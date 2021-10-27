# Oracle Docker Images

This repo provides two ways to automate the process of creating a prebuilt oracle docker image.

# Version 1
Link: [From Oracle Repo](https://github.com/KyleAure/oracle-docker-images/blob/master/version1/README.md)

This method was originally published by oracle and released under their Universal Permissive License.
The edits I made to this method was to pre-build the oracle database to improve performance at container runtime.

This container is published at: https://hub.docker.com/r/kyleaure/oracle-18.4.0-xe-prebuilt

# Version 2
Link: [From Oracle Dockerhub](https://github.com/KyleAure/oracle-docker-images/blob/master/version2/README.md)

This method involves expanding on the existing https://hub.docker.com/r/gvenzl/oracle-xe image released under the Apache 2.0 License.
The edits I made to this method was to decompress the oracle database to improve performance at container runtime.

This container is published at: https://hub.docker.com/r/kyleaure/oracle-18.4.0-slim-expanded