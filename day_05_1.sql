WITH line_point AS (
    SELECT 
        CASE WHEN y1 = y2 THEN i ELSE x1 END AS x_pos,
        CASE WHEN NOT y1 = y2 THEN i ELSE y1 END AS y_pos
    
    FROM aoc."2021_day_05" AS src
    
    INNER JOIN LATERAL (
        SELECT line_coordinates[1]::int, line_coordinates[2]::int, line_coordinates[3]::int, line_coordinates[4]::int
        FROM regexp_match(data, '(\d+),(\d+)\s->\s(\d+),(\d+)') AS line_coordinates
    ) AS _(x1, y1, x2, y2) ON TRUE
    
    INNER JOIN generate_series(
        CASE WHEN y1 = y2 THEN least(x1, x2) ELSE least(y1, y2) END,
        CASE WHEN y1 = y2 THEN greatest(x1, x2) ELSE greatest(y1, y2) END
    ) AS i ON TRUE
    
    WHERE (x1 = x2 OR y1 = y2)
)
SELECT count(*) OVER ()
FROM line_point
GROUP BY x_pos, y_pos
HAVING count(*) > 1
LIMIT 1;