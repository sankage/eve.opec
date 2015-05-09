# OPEC (Office of POS Electricity Consumption)

## SDD Update

* Login to server
* perform these commands

  ```bash
  $ su postgres
  $ cd
  $ wget https://www.fuzzwork.co.uk/dump/postgres-latest.dmp.bz2
  $ bzip2 -d postgres-latest.dmp.bz2
  $ pg_restore -d eve_static_data postgres-latest.dmp
  ```
