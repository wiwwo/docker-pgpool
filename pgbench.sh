pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -i
pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -c 10 -j 2 -t 10
pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -c 10 -j 2 -t 1000 -S
