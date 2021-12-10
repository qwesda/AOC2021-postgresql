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
), last_line AS (
    SELECT line_id, (array_agg(current_line ORDER BY step DESC))[1] AS reduced_line
    FROM line
    GROUP BY line_id
), line_score AS (
    SELECT 
        line_id, 
        reverse(reduced_line) AS remaining_line,
        0::bigint AS score
    FROM last_line
    WHERE ltrim(reduced_line, '<[{(') = ''
UNION ALL
    SELECT 
        line_id,
        substring(remaining_line, 2) AS remaining_line,
        line_score.score * 5 + (CASE substring(remaining_line, 1, 1) 
            WHEN '(' THEN 1
            WHEN '[' THEN 2
            WHEN '{' THEN 3
            WHEN '<' THEN 4
        END)        
    FROM line_score
    WHERE remaining_line != ''
)
SELECT percentile_disc(0.5) WITHIN GROUP (ORDER BY score)
FROM line_score
WHERE remaining_line = '';