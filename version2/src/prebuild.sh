#!/bin/bash
# Script built to pre-create database using base image here:
# https://hub.docker.com/r/gvenzl/oracle-xe

usage() {
  cat << EOF
Usage: prebuildv2.sh [-p [push] -u <docker-username> -v <docker-version>] [-?|-h help]
Builds a Docker Image for Oracle Database.
  
Parameters:
   -s: use slim image
   -f: use full image
   -p: perform a docker push after prebuilt database is created
      -u: (required) your dockerhub username
      -v: (required) version of resulting dockerhub image (ex 1.0, latest)
   -h: Help
EOF
}

#----- ARGUMENTS ------#
while getopts "sfpu:v:h" optname; do
  case $optname in
    "s") VERSION_SUFFIX="slim" ;;
    "f") VERSION_SUFFIX="full" ;;
    "p") DOCKER_PUSH=true ;;
    "u") DOCKER_USER="$OPTARG" ;;
    "v") DOCKER_VERSION="$OPTARG" ;;
    "h") usage; exit 0; ;;
    # Should not occur
    *) echo "Unknown error while processing options inside prebuild.sh" ;;
  esac
done

#----- VARIABLES ------#
#Working directories
DIR=$(pwd)

# Image information example: oracle/database:18.4.0-slim-expanded (prefix)/(postfix):(version)-(suffix)
PREFIX="oracle"                 #Constant
POSTFIX="database"              #Constant
VERSION_BASE="18.4.0"
SUFFIX="expanded"               #Suffix when pushing to external repo

if [ ! "${VERSION_SUFFIX}" ]; then
    VERSION="${VERSION_BASE}"
else 
    VERSION="${VERSION_BASE}-${VERSION_SUFFIX}"
fi


echo "Using version ${VERSION}"

# Docker arguments provided at build time
BUILD_ARGS="--squash"

# Base image information
BASE_IMAGE="gvenzl/oracle-xe:${VERSION}"

# Final image information
FINAL_IMAGE="${PREFIX}/${POSTFIX}:${VERSION}-${SUFFIX}"

#----- FUNCTIONS ------#
# Output using color to denote this scripts output
echoWithColor() {
    GREEN="\033[1;32m"
    NOCOLOR="\033[0m"
    IN=$1
    echo -e $GREEN$IN$NOCOLOR
}

# Set IMAGE_ID to the results of searching docker for the provided image name
getImageID() {
    IMAGE_ID=$(docker images -q $1)
    echoWithColor "Docker image id for $1 : $IMAGE_ID"
}

# This is when the container will be built and custom preconfiguration step will take place
dockerBuildBase() {    
    echoWithColor "---> Building Database Image from file ${VERSION}.Dockerfile"
    pushd ./config
        docker build -t $FINAL_IMAGE $BUILD_ARGS -f $VERSION.Dockerfile .
    popd
    echoWithColor "<--- Building Database Image"
}

# This is when we will push this container to dockerhub
dockerPush() {
    if [ ! "${VERSION_SUFFIX}" ]; then
        local EXTERNAL_IMAGE=$DOCKER_USER/$PREFIX-$VERSION_BASE-$SUFFIX:$DOCKER_VERSION
    else 
        local EXTERNAL_IMAGE=$DOCKER_USER/$PREFIX-$VERSION_BASE-$SUFFIX:$DOCKER_VERSION.$VERSION_SUFFIX
    fi

    echoWithColor "---> Pushing $EXTERNAL_IMAGE"

    docker login

    getImageID $EXTERNAL_IMAGE
    EXTERNAL_IMAGE_ID=$IMAGE_ID

    # If external image does not exist, tag it.
    if [ ! "${EXTERNAL_IMAGE_ID}" ]; then
        docker tag $FINAL_IMAGE $EXTERNAL_IMAGE
    else 
        echoWithColor "${EXTERNAL_IMAGE} image already exists, skipping tag step."
    fi

    # Push docker image
    docker push $EXTERNAL_IMAGE

    echoWithColor "<--- Pushing $EXTERNAL_IMAGE"
}

# Cleanup dangling images
cleanup() {
    echoWithColor "---> Cleaning Up"
    docker rmi $(docker images -f dangling=true -q)
    echoWithColor "<--- Cleaning Up"
}

#----- MAIN PROGRAM ------#

# Do the base or final images already exist?
getImageID $BASE_IMAGE
BASE_IMAGE_ID=$IMAGE_ID

getImageID $FINAL_IMAGE
FINAL_IMAGE_ID=$IMAGE_ID

# If base image does not exist, pull it.
if [ ! "${BASE_IMAGE_ID}" ]; then
    docker pull ${BASE_IMAGE}
else 
    echoWithColor "${BASE_IMAGE} image already exists, skipping pull step."
fi

# If final image does not exist, build it.
if [ ! "${FINAL_IMAGE_ID}" ]; then
    dockerBuildBase
else
    echoWithColor "${FINAL_IMAGE} image already exists, skipping build step."
fi

# Push to dockerhub
if [ -z ${DOCKER_PUSH+x} ]; then
    echoWithColor "Skipping push step"
else
    if [ -z ${DOCKER_USER+x} ]; then
        echoWithColor "Unable to push $FINAL_IMAGE to dockerhub."
        echoWithColor "One or more variables are undefined."
        echoWithColor "User: ${DOCKER_USER:-unset} Version: ${DOCKER_VERSION:-unset}"
    else
        dockerPush
    fi
fi

#Always cleanup
cleanup 2> /dev/null