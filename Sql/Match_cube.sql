CREATE VIEW agg.cube_team_match AS
SELECT
    a.match_id,
    t.team_id,
    t.team_name,
    a.goals,
    ROUND(a.xg::numeric, 2) AS xg,
    a.shots,
    a.passes,
    a.pressures
FROM agg.fact_team_match_stats a
JOIN dim.dim_team t
    ON a.team_id = t.team_id;
