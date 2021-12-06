WITH RECURSIVE population AS (
    SELECT 
        0 AS day,
        i AS fish_state,
        count(fish_state) AS fish_count
        
    FROM aoc."2021_day_06" AS src
    
    INNER JOIN generate_series(0, 8) AS i
            ON TRUE
    
    LEFT  JOIN regexp_split_to_table(src.data, ',') AS _(fish_state)
            ON fish_state::int = i
            
    GROUP BY 1, 2
UNION ALL
    SELECT         
        prev_population.day + 1 AS day,
        prev_population.fish_state,
        COALESCE(lead(prev_population.fish_count) OVER (w), 0) + CASE prev_population.fish_state 
            WHEN 6 THEN lag(prev_population.fish_count, 6) OVER (w) 
            WHEN 8 THEN lag(prev_population.fish_count, 8) OVER (w)
            ELSE 0
        END
    FROM population AS prev_population
    
    WHERE prev_population.day <= 80
    
    WINDOW w AS (ORDER BY prev_population.fish_state ASC)
)
SELECT sum(fish_count)
FROM population
WHERE day = 80;
