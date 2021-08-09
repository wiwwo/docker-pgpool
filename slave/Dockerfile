FROM postgres:11
RUN apt-get update && apt-get --assume-yes install iputils-ping ssh gosu curl
COPY ./setup-slave.sh /setup-slave.sh
RUN chmod +x /setup-slave.sh
ENTRYPOINT ["/setup-slave.sh"]
CMD ["gosu","postgres","postgres"]