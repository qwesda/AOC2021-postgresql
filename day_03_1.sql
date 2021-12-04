SELECT gamma::int * (~gamma)::int
FROM (
    SELECT
        (
            CASE WHEN count_1 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_2 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_3 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_4 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_5 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_6 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_7 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_8 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_9 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_10 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_11 > count_half THEN '1'::bit(1) ELSE '0'::bit END ||
            CASE WHEN count_12 > count_half THEN '1'::bit(1) ELSE '0'::bit END
        )::bit(12) AS gamma
    FROM (
        SELECT 
            count(*)/2 AS count_half,
            count(*) FILTER (WHERE substr(data, 1, 1) = '1') AS count_1,
            count(*) FILTER (WHERE substr(data, 2, 1) = '1') AS count_2,
            count(*) FILTER (WHERE substr(data, 3, 1) = '1') AS count_3,
            count(*) FILTER (WHERE substr(data, 4, 1) = '1') AS count_4,
            count(*) FILTER (WHERE substr(data, 5, 1) = '1') AS count_5,
            count(*) FILTER (WHERE substr(data, 6, 1) = '1') AS count_6,
            count(*) FILTER (WHERE substr(data, 7, 1) = '1') AS count_7,
            count(*) FILTER (WHERE substr(data, 8, 1) = '1') AS count_8,
            count(*) FILTER (WHERE substr(data, 9, 1) = '1') AS count_9,
            count(*) FILTER (WHERE substr(data, 10, 1) = '1') AS count_10,
            count(*) FILTER (WHERE substr(data, 11, 1) = '1') AS count_11,
            count(*) FILTER (WHERE substr(data, 12, 1) = '1') AS count_12
        FROM aoc."2021_day_03"
    ) AS src
) AS src;
