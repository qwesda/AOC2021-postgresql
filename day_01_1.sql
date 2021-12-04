SELECT count(*) FILTER (WHERE src.increased)
FROM (
    SELECT
        data > lag(data) OVER (ORDER BY id ASC) AS increased
    FROM aoc.day_01
) AS src;
