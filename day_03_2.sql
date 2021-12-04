WITH RECURSIVE foo AS (
    SELECT
        1 AS pos,
        (char = (CASE WHEN count_1 >= count_0 THEN '1' ELSE '0' END)) AS is_generator,
        data
    FROM (
        SELECT
            data,
            substr(data, 1, 1) AS char,
            count(*) FILTER (WHERE substr(data, 1, 1) = '0') OVER () AS count_0,
            count(*) FILTER (WHERE substr(data, 1, 1) = '1') OVER () AS count_1
        FROM aoc."2021_day_03"
    ) AS bar
    WHERE (char = (CASE WHEN count_1 >= count_0 THEN '1' ELSE '0' END))
       OR (char = (CASE WHEN count_0 <= count_1 THEN '0' ELSE '1' END))
UNION ALL
    SELECT 
        pos + 1 AS pos,
        is_generator,
        data
    FROM (
        SELECT
            pos,
            is_generator,
            data,
            substr(data, pos+1, 1) AS char,
            count(*) FILTER (WHERE substr(data, pos+1, 1) = '0') OVER (PARTITION BY pos, is_generator) AS count_0,
            count(*) FILTER (WHERE substr(data, pos+1, 1) = '1') OVER (PARTITION BY pos, is_generator) AS count_1
        FROM foo
    ) AS bar
    WHERE (is_generator = TRUE  AND (char = (CASE WHEN count_1 >= count_0 THEN '1' ELSE '0' END)))
       OR (is_generator = FALSE AND (char = (CASE WHEN count_0 <= count_1 THEN '0' ELSE '1' END)))
       
)
SELECT max(data_int) * min(data_int) -- there is no multiply aggregate 
FROM (
    SELECT data::bit(12)::int
    FROM foo
    WHERE (is_generator = TRUE  AND pos = ANY(SELECT max(pos) FROM foo WHERE is_generator = TRUE))
       OR (is_generator = FALSE AND pos = ANY(SELECT max(pos) FROM foo WHERE is_generator = FALSE))
) AS src;
