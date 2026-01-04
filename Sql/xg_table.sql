DROP TABLE IF EXISTS fact.shot_model;

CREATE TABLE fact.shot_model AS
SELECT
    -- identifiers (keep for reference, not modeling)
    e.event_id,
    e.match_id,
    e.team_id,
    e.player_id,

    -- target
    CASE
        WHEN s.shot_outcome = 'Goal' THEN 1
        ELSE 0
    END AS is_goal,

    -- raw location
    e.x AS shot_x,
    e.y AS shot_y,

    -- derived features
    SQRT(
        POWER(120 - e.x, 2) +
        POWER(40 - e.y, 2)
    ) AS distance_to_goal,

    ABS(
        ATAN2(44 - e.y, 120 - e.x) -
        ATAN2(36 - e.y, 120 - e.x)
    ) AS shot_angle,

    -- context
    e.under_pressure,

    -- shot characteristics
    s.shot_body_part,
    s.shot_type,
    s.shot_technique,
    s.shot_first_time,
    s.shot_one_on_one,

    -- benchmark (DO NOT TRAIN ON THIS)
    s.shot_statsbomb_xg

FROM fact.fact_event e
JOIN fact.fact_shot s
    ON e.event_id = s.event_id
WHERE e.event_type = 'Shot';
