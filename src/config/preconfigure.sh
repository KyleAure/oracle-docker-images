#!/bin/bash

# Perform time intensive unzip before pushing container.  
# This will reduce performance impacts of uncompressing these files each time a new container is started. 
# But will increase the overall size of the image. 
# I feel like this is a tradeoff worth making. 

if [ -f "${ORACLE_BASE}"/"${ORACLE_SID}".zip ]; then
    echo "CONTAINER: uncompressing database data files, please wait..."
    EXTRACT_START_TMS=$(date '+%s')
    unzip "${ORACLE_BASE}"/"${ORACLE_SID}".zip -d "${ORACLE_BASE}"/oradata/ 1> /dev/null
    EXTRACT_END_TMS=$(date '+%s')
    EXTRACT_DURATION=$(( EXTRACT_END_TMS - EXTRACT_START_TMS ))
    echo "CONTAINER: done uncompressing database data files, duration: ${EXTRACT_DURATION} seconds."
    rm "${ORACLE_BASE}"/"${ORACLE_SID}".zip
fi;

mkdir -p "${ORACLE_BASE}/oradata/dbconfig/${ORACLE_SID}"

mv "${ORACLE_HOME}"/dbs/spfile"${ORACLE_SID}".ora "${ORACLE_BASE}"/oradata/dbconfig/"${ORACLE_SID}"/
mv "${ORACLE_HOME}"/dbs/orapw"${ORACLE_SID}" "${ORACLE_BASE}"/oradata/dbconfig/"${ORACLE_SID}"/
mv "${ORACLE_HOME}"/network/admin/listener.ora "${ORACLE_BASE}"/oradata/dbconfig/"${ORACLE_SID}"/
mv "${ORACLE_HOME}"/network/admin/tnsnames.ora "${ORACLE_BASE}"/oradata/dbconfig/"${ORACLE_SID}"/
mv "${ORACLE_HOME}"/network/admin/sqlnet.ora "${ORACLE_BASE}"/oradata/dbconfig/"${ORACLE_SID}"/