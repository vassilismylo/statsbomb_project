CREATE VIEW agg.cube_player_season AS
SELECT
    p.player_id,
    p.player_name,
    p.position_name,
    s.season_id,
    s.season_name,

    COUNT(DISTINCT a.match_id) AS matches_played,
    SUM(a.goals) AS goals,
    ROUND(SUM(a.xg)::numeric, 2) AS xg,
    SUM(a.shots) AS shots,
    SUM(a.passes) AS passes,
    SUM(a.pressures) AS pressures

FROM agg.fact_player_match_stats a
JOIN dim.dim_player p
    ON a.player_id = p.player_id
JOIN dim.dim_match m
    ON a.match_id = m.match_id
JOIN dim.dim_season s
    ON s.season_id = (
        SELECT season_id FROM dim.dim_season LIMIT 1
    )
GROUP BY
    p.player_id, p.player_name, p.position_name,
    s.season_id, s.season_name;
