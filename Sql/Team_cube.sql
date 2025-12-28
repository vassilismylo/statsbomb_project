CREATE VIEW agg.cube_team_season AS
SELECT
    t.team_id,
    t.team_name,
    s.season_id,
    s.season_name,
    c.competition_id,
    c.competition_name,

    COUNT(DISTINCT a.match_id) AS matches_played,
    SUM(a.goals) AS goals,
    ROUND(SUM(a.xg)::numeric, 2) AS xg,
    SUM(a.shots) AS shots,
    SUM(a.passes) AS passes,
    SUM(a.pressures) AS pressures

FROM agg.fact_team_match_stats a
JOIN dim.dim_team t
    ON a.team_id = t.team_id
JOIN dim.dim_match m
    ON a.match_id = m.match_id
JOIN dim.dim_season s
    ON s.season_id = (
        SELECT season_id FROM dim.dim_season LIMIT 1
    )
JOIN dim.dim_competition c
    ON c.competition_id = (
        SELECT competition_id FROM dim.dim_competition LIMIT 1
    )
GROUP BY
    t.team_id, t.team_name,
    s.season_id, s.season_name,
    c.competition_id, c.competition_name;
