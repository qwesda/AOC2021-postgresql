WITH coded_signal AS (
    SELECT 
        src.id AS display_id,
        coded_didgit,
        coded_didgit_binary,
        bit_count(coded_didgit_binary)::smallint AS bit_count
    FROM aoc."2021_day_08" AS src
    CROSS JOIN regexp_split_to_array(src.data, '\s\|\s') AS data_split
    CROSS JOIN regexp_split_to_table(data_split[1], '\s') AS coded_didgit
    CROSS JOIN LATERAL (
        SELECT
            CASE WHEN strpos(coded_didgit, 'a') > 0 THEN '1000000'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'b') > 0 THEN '0100000'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'c') > 0 THEN '0010000'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'd') > 0 THEN '0001000'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'e') > 0 THEN '0000100'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'f') > 0 THEN '0000010'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'g') > 0 THEN '0000001'::bit(7) ELSE '0000000'::bit(7) END AS coded_didgit_binary
    ) AS _
), decode_step_1 AS (
    SELECT 
        display_id,
        bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 2) AS binary_1,
        bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 4) AS binary_4,
        bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 3) AS binary_7,
        bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 7) AS binary_8
    FROM coded_signal
    GROUP BY display_id
), decode_step_2 AS (
    SELECT 
        decode_step_1.display_id,
        ARRAY[
            binary_1,
            bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 5 AND binary_4 | coded_didgit_binary = binary_8),
            bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 5 AND binary_1 | coded_didgit_binary = coded_didgit_binary),
            binary_4,
            bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 5 AND NOT (binary_1 | coded_didgit_binary = coded_didgit_binary) AND NOT (binary_4 | coded_didgit_binary = binary_8)),
            bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 6 AND binary_1 | coded_didgit_binary = binary_8),
            binary_7,
            binary_8,
            bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 6 AND bit_count(binary_4 | coded_didgit_binary) = 6),
            bit_and(coded_didgit_binary) FILTER (WHERE bit_count = 6 AND NOT (binary_1 | coded_didgit_binary = binary_8) AND NOT (bit_count(binary_4 | coded_didgit_binary) = 6))
        ] AS decodes_signals
    FROM decode_step_1
    INNER JOIN coded_signal 
            ON coded_signal.display_id = decode_step_1.display_id
           AND coded_signal.bit_count IN (5, 6)
    GROUP BY decode_step_1.display_id, binary_1, binary_4, binary_7, binary_8
), decode_mapping AS (
    SELECT 
        display_id,
        signal, 
        digit % 10 AS digit
    FROM decode_step_2
    CROSS JOIN unnest(decodes_signals) WITH ORDINALITY AS _(signal, digit)
), decoded_output AS (
    SELECT 
        src.id AS display_id,
        sum(digit * pow(10, 4-i)) AS value
    FROM aoc."2021_day_08" AS src
    CROSS JOIN regexp_split_to_array(src.data, '\s\|\s') AS data_split
    CROSS JOIN regexp_split_to_table(data_split[2], '\s') WITH ORDINALITY AS s(coded_didgit, i)
    CROSS JOIN LATERAL (
        SELECT
            CASE WHEN strpos(coded_didgit, 'a') > 0 THEN '1000000'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'b') > 0 THEN '0100000'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'c') > 0 THEN '0010000'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'd') > 0 THEN '0001000'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'e') > 0 THEN '0000100'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'f') > 0 THEN '0000010'::bit(7) ELSE '0000000'::bit(7) END |
            CASE WHEN strpos(coded_didgit, 'g') > 0 THEN '0000001'::bit(7) ELSE '0000000'::bit(7) END AS coded_didgit_binary
    ) AS _
    INNER JOIN decode_mapping
            ON decode_mapping.display_id = src.id
           AND decode_mapping.signal = coded_didgit_binary
    GROUP BY 1
)
SELECT sum(value)
FROM decoded_output;