WITH RECURSIVE map AS (
    SELECT 
        x_pos::int,
        y_pos::int,
        height AS height_self,
        
        lag(height) OVER (PARTITION BY x_pos ORDER BY y_pos) AS height_up,
        lead(height) OVER (PARTITION BY x_pos ORDER BY y_pos) AS height_down,
        lag(height) OVER (PARTITION BY y_pos ORDER BY x_pos) AS height_left,
        lead(height) OVER (PARTITION BY y_pos ORDER BY x_pos) AS height_right
    FROM aoc."2021_day_09" AS src(y_pos, data)
    CROSS JOIN regexp_split_to_table(src.data, '') WITH ORDINALITY AS _(height_text, x_pos)
    CROSS JOIN LATERAL (SELECT height_text::int) AS __(height)
), flow AS (
    SELECT 
        map_from.x_pos AS from_x_pos,
        map_from.y_pos AS from_y_pos,
        
        map_to.x_pos AS to_x_pos,
        map_to.y_pos AS to_y_pos
    FROM map AS map_from
    INNER JOIN map AS map_to
            ON (abs(map_to.x_pos - map_from.x_pos) + abs(map_to.y_pos - map_from.y_pos)) = 1
           AND map_from.height_self > map_to.height_self
    WHERE map_from.height_self < 9
), map_with_drain AS (
    (SELECT 
        x_pos,
        y_pos,
        x_pos AS x_drain,
        y_pos AS y_drain
    FROM map   
    
    WHERE height_self < height_up IS DISTINCT FROM FALSE
      AND height_self < height_down IS DISTINCT FROM FALSE
      AND height_self < height_left IS DISTINCT FROM FALSE
      AND height_self < height_right IS DISTINCT FROM FALSE
    ORDER BY x_pos, y_pos
    LIMIT 1000) -- without this the choosen plan is much slower
UNION ALL
    SELECT
        flow.from_x_pos,
        flow.from_y_pos,
        map_with_drain.x_drain,
        map_with_drain.y_drain
    FROM map_with_drain
    INNER JOIN flow
            ON flow.to_x_pos = map_with_drain.x_pos
           AND flow.to_y_pos = map_with_drain.y_pos
), basins AS (
    SELECT x_drain, y_drain, count(*) AS size
    FROM (
        SELECT 
            x_pos, 
            y_pos, 
            min(x_drain) AS x_drain, 
            min(y_drain) AS y_drain
        FROM map_with_drain
        GROUP BY x_pos, y_pos
        HAVING count(DISTINCT (x_drain, y_drain)) = 1
    ) AS without_ambiguous_drains
    GROUP BY x_drain, y_drain
)
SELECT 
    -- I did consider using a custom aggregate, but I stuck to vanilla postgres ... but this is quite ugly
    size * lead(size) OVER (ORDER BY size) * lead(size, 2) OVER (ORDER BY size)
FROM (
    SELECT size
    FROM basins
    ORDER BY size DESC
    LIMIT 3
) AS _
LIMIT 1;
