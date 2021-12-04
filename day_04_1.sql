WITH RECURSIVE bord_state AS (
    SELECT 
        bord.bord_id,
        bord.row_or_col_index,
        bord.row_numbers,
        bord.col_numbers,
        0::bigint AS draw_id,
        B'011111'::bit(6) AS row_state,
        B'011111'::bit(6) AS col_state
    FROM bord
UNION ALL
    SELECT 
        bord_state.bord_id,
        bord_state.row_or_col_index,
        bord_state.row_numbers,
        bord_state.col_numbers,
        draw.draw_id,
        set_bit(bord_state.row_state, COALESCE(array_position(bord_state.row_numbers, draw.number), 0), 0)::bit(6) AS row_state,
        set_bit(bord_state.col_state, COALESCE(array_position(bord_state.col_numbers, draw.number), 0), 0)::bit(6) AS col_state
    FROM bord_state 
    INNER JOIN draw 
            ON draw.draw_id = bord_state.draw_id + 1
), draw AS (
    SELECT 
        draw.draw_id,
        draw.number::int
    FROM aoc."2021_day_04"
    INNER JOIN regexp_split_to_table(data, ',') WITH ORDINALITY draw(number, draw_id) 
            ON TRUE
    WHERE id = 1
), bord AS (
    SELECT 
        (src.id - 2) / 6 AS bord_id,
        row_or_col_index,
        array_agg(foo.number::int ORDER BY col_id) FILTER (WHERE (src.id - 2) % 6 = row_or_col_index) AS row_numbers,
        array_agg(foo.number::int ORDER BY (src.id - 2) % 6) FILTER (WHERE col_id = row_or_col_index) AS col_numbers
        
    FROM aoc."2021_day_04" AS src

    INNER JOIN regexp_split_to_table(trim(data), '\s+') WITH ORDINALITY foo(number, col_id) 
            ON TRUE
    INNER JOIN generate_series(1, 5) AS row_or_col_index
            ON TRUE

    WHERE id > 1
      AND data != ''
    GROUP BY 1, 2
), winning_draw AS (
    SELECT 
        bord_state.bord_id,
        bord_state.draw_id,
        draw.number
    FROM bord_state
    INNER JOIN draw 
            ON draw.draw_id = bord_state.draw_id
    WHERE row_state = 0::bit(6)
       OR col_state = 0::bit(6)
    ORDER BY draw_id
    LIMIT 1
)
SELECT sum(foo.number) * winning_draw.number
FROM winning_draw
INNER JOIN bord_state
        ON bord_state.bord_id = winning_draw.bord_id
       AND bord_state.draw_id = winning_draw.draw_id
INNER JOIN unnest(bord_state.row_numbers) WITH ORDINALITY foo(number, col_id) 
        ON get_bit(row_state, col_id::int) = 1
GROUP BY winning_draw.number;