SELECT 
    sum(CASE substr(data, 1, 1)
        WHEN 'f' THEN split_part(data, ' ', 2)::int
    END) *
    sum(CASE substr(data, 1, 1)
        WHEN 'd' THEN split_part(data, ' ', 2)::int
        WHEN 'u' THEN split_part(data, ' ', 2)::int * -1
    END)
FROM aoc.day_02;
