FROM gvenzl/oracle-xe:18.4.0-full

#Enable healthcheck
ENV CHECK_DB_FILE="healthcheck.sh"

#Copy scripts
COPY preconfigure.sh ${ORACLE_BASE}/preconfigure.sh
COPY container-entrypoint.sh ${ORACLE_BASE}/container-entrypoint.sh

#Ensure scripts are runnable
USER root
RUN chown oracle:dba ${ORACLE_BASE}/preconfigure.sh && \
    chown oracle:dba ${ORACLE_BASE}/container-entrypoint.sh && \
    chmod ug+x ${ORACLE_BASE}/preconfigure.sh && \
    chmod ug+x ${ORACLE_BASE}/container-entrypoint.sh

#Contains vulnerable log4j library for a feature not need for SSL or Kerberos authentication
RUN rm -rf /opt/oracle/product/18c/dbhomeXE/md/property_graph/
USER oracle

#Run preconfigure step
RUN ${ORACLE_BASE}/preconfigure.sh
RUN rm ${ORACLE_BASE}/preconfigure.sh

#Expose port
EXPOSE 1521

#Configure healthcheck
HEALTHCHECK --interval=30s --start-period=15m \
  CMD ${ORACLE_BASE}/${CHECK_DB_FILE} >/dev/null || exit 1