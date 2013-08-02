# SQL helper library

## Usage:
```erlang
Query = "select * from whatever where id = ? or status in ? or name like ?",
Args = [1, [10,20],<<"john doe">>],
Parsed_query = sql:process_query(Query, Args)
```