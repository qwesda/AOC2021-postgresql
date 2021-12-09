WITH map AS (
    SELECT 
        id AS x_pos,
        y_pos,
        height AS height_self,
        
        lag(height) OVER (PARTITION BY id ORDER BY y_pos) AS height_up,
        lead(height) OVER (PARTITION BY id ORDER BY y_pos) AS height_down,
        lag(height) OVER (PARTITION BY y_pos ORDER BY id) AS height_left,
        lead(height) OVER (PARTITION BY y_pos ORDER BY id) AS height_right
    FROM aoc."2021_day_09" AS src
    CROSS JOIN regexp_split_to_table(src.data, '') WITH ORDINALITY AS _(height_text, y_pos)
    CROSS JOIN LATERAL (SELECT height_text::int) AS __(height)
)
SELECT 
    sum(height_self + 1)
FROM map
WHERE height_self < height_up IS DISTINCT FROM FALSE
  AND height_self < height_down IS DISTINCT FROM FALSE
  AND height_self < height_left IS DISTINCT FROM FALSE
  AND height_self < height_right IS DISTINCT FROM FALSE;