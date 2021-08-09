FROM pgpool/pgpool
COPY --chown=postgres ./failover.sh /failover.sh
RUN chown postgres: /failover.sh
RUN chmod 0777 /failover.sh