SELECT 
    count(*)
FROM aoc."2021_day_08" AS src
CROSS JOIN regexp_split_to_array(src.data, '\s\|\s') AS _(data_split)
CROSS JOIN regexp_split_to_table(data_split[2], '\s') AS output_value
WHERE length(output_value) IN (2, 3, 4, 7);