# AOC2021-postgresql

Let's see how far this can go ...

All input is assumed to be already ingested in a table like:

```sql
CREATE TABLE aoc."2021_day_01" (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    data integer
);
```
