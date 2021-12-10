WITH RECURSIVE line AS (
    SELECT 
        src.line_id, 
        1 AS step,
        src.original_line,
        regexp_replace(original_line, '\[\]|\<\>|\(\)|\{\}', '', 'g') AS current_line
    FROM aoc."2021_day_10" AS src(line_id, original_line)

UNION ALL

    SELECT 
        prev_line.line_id, 
        step + 1 AS step,
        original_line,
        replaced AS current_line
    FROM line AS prev_line
    CROSS JOIN LATERAL (SELECT regexp_replace(current_line, '\[\]|\<\>|\(\)|\{\}', '', 'g')) AS _(replaced)
    WHERE replaced != current_line
)
SELECT sum(CASE c
        WHEN ')' THEN 3
        WHEN ']' THEN 57
        WHEN '}' THEN 1197
        WHEN '>' THEN 25137
    END)
FROM (
    SELECT substr(ltrim((array_agg(current_line ORDER BY step DESC))[1], '<[{('), 1, 1) AS c
    FROM line
    GROUP BY line_id
) AS src;
