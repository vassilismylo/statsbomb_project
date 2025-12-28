SELECT team_name, goals, xg
FROM agg.cube_team_season
ORDER BY goals DESC;

SELECT
    team_name,
    goals,
    shots,
    passes
FROM agg.cube_team_season
ORDER BY goals DESC;
