CREATE SCHEMA IF NOT EXISTS dim;
CREATE SCHEMA IF NOT EXISTS fact;
CREATE SCHEMA IF NOT EXISTS agg;


CREATE TABLE dim.dim_team (
    team_id INTEGER PRIMARY KEY,
    team_name TEXT NOT NULL
);
CREATE TABLE dim.dim_player (
    player_id INTEGER PRIMARY KEY,
    player_name TEXT NOT NULL,
    position_name TEXT
);
CREATE TABLE dim.dim_match (
    match_id INTEGER PRIMARY KEY,
    match_date DATE,
    kick_off TIME,
    home_team_name TEXT,
    away_team_name TEXT,
    home_score INTEGER,
    away_score INTEGER,
    match_week INTEGER
);
CREATE TABLE dim.dim_competition (
    competition_id INTEGER PRIMARY KEY,
    competition_name TEXT NOT NULL,
    country_name TEXT
);
CREATE TABLE dim.dim_season (
    season_id INTEGER PRIMARY KEY,
    season_name TEXT NOT NULL
);
