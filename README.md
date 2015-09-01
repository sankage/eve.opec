# OPEC (Office of POS Electricity Consumption)

## SDD Update

* Login to server
* perform these commands

  ```bash
  $ su postgres
  $ cd
  $ wget https://www.fuzzwork.co.uk/dump/postgres-latest.dmp.bz2
  $ bzip2 -f -d postgres-latest.dmp.bz2
  $ pg_restore --clean \
               --username=eve \
               --host=127.0.0.1 \
               --dbname=eve_static_data \
               postgres-latest.dmp
  ```
