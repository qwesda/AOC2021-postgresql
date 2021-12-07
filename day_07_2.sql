WITH positions AS (
    SELECT 
        crab_pos::int,
        min(crab_pos::int) OVER (),
        max(crab_pos::int) OVER ()
        
    FROM aoc."2021_day_07" AS src
    
    CROSS JOIN regexp_split_to_table(src.data, ',') AS _(crab_pos)
)
SELECT 
    sum(((abs(target_pos - crab_pos) + 1) * (abs(target_pos - crab_pos)))/2) AS fuel_spent
FROM positions
CROSS JOIN generate_series(positions.min, positions.max) AS target_pos
GROUP BY target_pos
ORDER BY 1 ASC
LIMIT 1;
