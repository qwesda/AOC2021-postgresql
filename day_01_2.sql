SELECT count(*) FILTER (WHERE window_next_data > window_prev_data AND src.data_count = 4)
FROM (
    SELECT
        count(data) OVER (ORDER BY id ASC ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) AS data_count,
        sum(data) OVER (ORDER BY id ASC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS window_prev_data,
        sum(data) OVER (ORDER BY id ASC ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS window_next_data
    FROM aoc.day_01
) AS src;
