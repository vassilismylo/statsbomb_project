CREATE TABLE agg.fact_team_match_stats (
    match_id INTEGER NOT NULL,
    team_id INTEGER NOT NULL,
    events INTEGER,
    passes INTEGER,
    shots INTEGER,
    carries INTEGER,
    pressures INTEGER,
    goals INTEGER,
    xg DOUBLE PRECISION,
    PRIMARY KEY (match_id, team_id)
);
CREATE TABLE agg.fact_player_match_stats (
    match_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    events INTEGER,
    passes INTEGER,
    shots INTEGER,
    carries INTEGER,
    pressures INTEGER,
    goals INTEGER,
    xg DOUBLE PRECISION,
    PRIMARY KEY (match_id, player_id)
);
