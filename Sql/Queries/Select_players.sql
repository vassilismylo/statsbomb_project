SELECT player_name, goals, xg ,(goals - xg) as xg_diff
FROM agg.cube_player_season
ORDER BY xg_diff DESC
LIMIT 30;
