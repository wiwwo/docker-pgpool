docker kill docker-pgpool_pgpool_1 docker-pgpool_pg_green_1 docker-pgpool_pg_blue_1; sleep 2; docker kill docker-pgpool_pg_red
docker-compose down
docker volume rm docker-pgpool_pg_blue_data docker-pgpool_pg_green_data docker-pgpool_pg_red_data docker-pgpool_shared_temp docker-pgpool_shared_tmp
docker system prune -f
