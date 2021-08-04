# Init

```
$ docker network create bridge-docker
$ docker-compose up -d
```

`$ docker ps`

If you have one...
```
$ echo "localhost:9999:postgres:optima:123456" >> ~/.pgpass
$ echo "localhost:5445:postgres:optima:123456" >> ~/.pgpass
$ echo "localhost:5446:postgres:optima:123456" >> ~/.pgpass
```

# To connect to instances
`$ psql -h localhost -Uoptima postgres -p5445`
`$ psql -h localhost -Uoptima postgres -p5446`
`$ psql -h localhost -Uoptima postgres -p9999`


# pgBench

`$ pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -i`
`$ pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -c 10 -j 2 -t 100`

`$ psql -h localhost -Uoptima postgres -p9999 -c "show pool_nodes;"`

```
 node_id |  hostname   | port | status | lb_weight |  role   | select_cnt | load_balance_node | replication_delay | repl
---------+-------------+------+--------+-----------+---------+------------+-------------------+-------------------+-----
 0       | pg_master_1 | 5432 | up     | 0.500000  | primary | 1001       | true              | 0                 |
 1       | pg_slave_1  | 5432 | up     | 0.500000  | standby | 3          | false             | 0                 |
(2 rows)
```

`$ pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -c 10 -j 2 -t 100 -S`

`$ psql -h localhost -Uoptima postgres -p9999 -c "show pool_nodes;"`

```
 node_id |  hostname   | port | status | lb_weight |  role   | select_cnt | load_balance_node | replication_delay | repl
---------+-------------+------+--------+-----------+---------+------------+-------------------+-------------------+-----
 0       | pg_master_1 | 5432 | up     | 0.500000  | primary | 1903       | true              | 0                 |
 1       | pg_slave_1  | 5432 | up     | 0.500000  | standby | 104        | false             | 0                 |
(2 rows)
```

### Changing weight
(in `docker-compose.yml`)
```
         - PGPOOL_PARAMS_BACKEND_WEIGHT0=0.1
         - PGPOOL_PARAMS_BACKEND_WEIGHT1=0.9
```

`$ psql -h localhost -Uoptima postgres -p9999 -c "show pool_nodes;"`

```
 node_id |  hostname   | port | status | lb_weight |  role   | select_cnt | load_balance_node | replication_delay | replication_state | replication_sync_st
---------+-------------+------+--------+-----------+---------+------------+-------------------+-------------------+-------------------+--------------------
 0       | pg_master_1 | 5432 | up     | 0.100000  | primary | 0          | false             | 0                 |                   |
 1       | pg_slave_1  | 5432 | up     | 0.900000  | standby | 0          | true              | 2971432           |                   |
(2 rows)
```

`$ pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -c 10 -j 2 -t 100`

```
 node_id |  hostname   | port | status | lb_weight |  role   | select_cnt | load_balance_node | replication_delay | replication_state | replication_sync_st
---------+-------------+------+--------+-----------+---------+------------+-------------------+-------------------+-------------------+--------------------
 0       | pg_master_1 | 5432 | up     | 0.100000  | primary | 1001       | false             | 0                 |                   |
 1       | pg_slave_1  | 5432 | up     | 0.900000  | standby | 1          | true              | 0                 |                   |
```

`$ pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -c 10 -j 2 -t 100 -S`

``` 
node_id |  hostname   | port | status | lb_weight |  role   | select_cnt | load_balance_node | replication_delay | replication_state | replication_sync_st
---------+-------------+------+--------+-----------+---------+------------+-------------------+-------------------+-------------------+--------------------
 0       | pg_master_1 | 5432 | up     | 0.100000  | primary | 1102       | false             | 0                 |                   |
 1       | pg_slave_1  | 5432 | up     | 0.900000  | standby | 901        | true              | 0                 |                   |
```

`$ pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -c 10 -j 2 -t 100`

```
 node_id |  hostname   | port | status | lb_weight |  role   | select_cnt | load_balance_node | replication_delay | replication_state | replication_sync_st
---------+-------------+------+--------+-----------+---------+------------+-------------------+-------------------+-------------------+--------------------
 0       | pg_master_1 | 5432 | up     | 0.100000  | primary | 2103       | false             | 0                 |                   |
 1       | pg_slave_1  | 5432 | up     | 0.900000  | standby | 902        | true              | 0                 |                   |
```

`$ pgbench  -h localhost -p9999  -Uoptima postgres -p9999  -c 10 -j 2 -t 100 -S`

```
 node_id |  hostname   | port | status | lb_weight |  role   | select_cnt | load_balance_node | replication_delay | replication_state | replication_sync_st
---------+-------------+------+--------+-----------+---------+------------+-------------------+-------------------+-------------------+--------------------
 0       | pg_master_1 | 5432 | up     | 0.100000  | primary | 2104       | false             | 0                 |                   |
 1       | pg_slave_1  | 5432 | up     | 0.900000  | standby | 1903       | true              | 0                 |                   |
```

*IMPORATNT TO NOTE* Since `pgbench` uses transactions to run the full test, select statements are not distributed to the slave, but executed on the master. Avoiding "BEGIN/COMMIT" in `pgbench` test internal will "solve" this


# Sources
https://bitbucket.org/CraigOptimaData/docker-pg-cluster.git
https://b-peng.blogspot.com/2021/07/deploying-pgpool2-exporter-with-docker.html

Cool stuff:
https://github.com/postmart/docker_pgpool

More very cool stuff:
https://saule1508.github.io/pgpool/
