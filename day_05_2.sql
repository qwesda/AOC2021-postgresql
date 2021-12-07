WITH line_point AS (
    SELECT 
        CASE 
            WHEN x1 = x2 THEN x1
            ELSE x1 + CASE WHEN x2 > x1 THEN i ELSE -i END
        END AS x_pos,
        
        CASE 
            WHEN y1 = y2 THEN y1
            ELSE y1 + CASE WHEN y2 > y1 THEN i ELSE -i END
        END AS y_pos

    FROM aoc."2021_day_05" AS src

    CROSS JOIN LATERAL (
        SELECT line_coordinates[1]::int, line_coordinates[2]::int, line_coordinates[3]::int, line_coordinates[4]::int
        FROM regexp_match(data, '(\d+),(\d+)\s->\s(\d+),(\d+)') AS line_coordinates
    ) AS _(x1, y1, x2, y2)
            
    CROSS JOIN generate_series(0, greatest(
        greatest(x1, x2) - least(x1, x2),
        greatest(y1, y2) - least(y1, y2)
    )) AS i
)
SELECT count(*) OVER ()
FROM line_point
GROUP BY x_pos, y_pos
HAVING count(*) > 1
LIMIT 1;
