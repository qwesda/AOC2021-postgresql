WITH positions AS (
    SELECT 
        crab_pos::int,
        min(crab_pos::int) OVER (),
        max(crab_pos::int) OVER ()
        
    FROM aoc."2021_day_07" AS src
    
    INNER JOIN regexp_split_to_table(src.data, ',') AS _(crab_pos)
            ON TRUE
)
SELECT 
    target_pos,
    sum(((abs(target_pos - crab_pos) + 1) * (abs(target_pos - crab_pos)))/2) AS fuel_spent
FROM positions
INNER JOIN generate_series(positions.min, positions.max) AS target_pos
        ON TRUE
GROUP BY target_pos
ORDER BY 2 ASC
LIMIT 1;
