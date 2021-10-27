FROM gvenzl/oracle-xe:18.4.0-slim

ENV CHECK_DB_FILE="healthcheck.sh"

COPY preconfigure.sh ${ORACLE_BASE}/preconfigure.sh
COPY container-entrypoint.sh ${ORACLE_BASE}/container-entrypoint.sh

USER root
RUN chown oracle:dba ${ORACLE_BASE}/preconfigure.sh && \
    chown oracle:dba ${ORACLE_BASE}/container-entrypoint.sh && \
    chmod ug+x ${ORACLE_BASE}/preconfigure.sh && \
    chmod ug+x ${ORACLE_BASE}/container-entrypoint.sh

USER oracle
RUN ${ORACLE_BASE}/preconfigure.sh

RUN rm ${ORACLE_BASE}/preconfigure.sh

HEALTHCHECK --interval=30s --start-period=15m \
  CMD ${ORACLE_BASE}/${CHECK_DB_FILE} >/dev/null || exit 1