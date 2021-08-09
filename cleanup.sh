docker kill docker-pgpool_pgpool_1 docker-pgpool_pg_slave_1_1 docker-pgpool_pg_slave_2_1; sleep 2; docker kill docker-pgpool_pg_master_1_1
docker-compose down
docker volume rm docker-pgpool_sdata{,1,2} docker-pgpool_stmp docker-pgpool_mdata
docker system prune -f
