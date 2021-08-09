FROM postgres:11
COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh
RUN chmod 0666 /docker-entrypoint-initdb.d/setup-master.sh
RUN apt-get update && apt-get --assume-yes install iputils-ping ssh gosu curl