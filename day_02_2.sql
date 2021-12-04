SELECT sum(movement) * sum(movement * depth_aim)
FROM (
    SELECT
        CASE WHEN substr(data, 1, 1) = 'f' THEN split_part(data, ' ', 2)::int END AS movement,
        sum(CASE substr(data, 1, 1)
            WHEN 'd' THEN split_part(data, ' ', 2)::int
            WHEN 'u' THEN split_part(data, ' ', 2)::int * -1
        END) OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS depth_aim
    FROM aoc.day_02
) AS src;
