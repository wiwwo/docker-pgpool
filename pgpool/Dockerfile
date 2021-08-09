FROM pgpool/pgpool
COPY ./setup-pgpool.sh /docker-entrypoint-initdb.d/setup-pgpool.sh
RUN chmod 0666 /docker-entrypoint-initdb.d/setup-pgpool.sh
