CREATE TABLE fact.fact_event (
    event_id TEXT PRIMARY KEY,
    match_id INTEGER NOT NULL,
    team_id INTEGER NOT NULL,
    player_id INTEGER,
    period SMALLINT,
    minute SMALLINT,
    second SMALLINT,
    event_type TEXT,
    event_category TEXT,
    possession INTEGER,
    possession_team_id INTEGER,
    under_pressure BOOLEAN,
    x DOUBLE PRECISION,
    y DOUBLE PRECISION,
    is_pass BOOLEAN,
    is_shot BOOLEAN,
    is_carry BOOLEAN,
    is_pressure BOOLEAN
);

CREATE TABLE fact.fact_pass (
    event_id TEXT PRIMARY KEY,
    end_x DOUBLE PRECISION,
    end_y DOUBLE PRECISION,
    pass_length DOUBLE PRECISION,
    pass_angle DOUBLE PRECISION,
    pass_height TEXT,
    pass_type TEXT,
    pass_outcome TEXT,
    pass_recipient_name TEXT
);

CREATE TABLE fact.fact_shot (
    event_id TEXT PRIMARY KEY,
    shot_statsbomb_xg DOUBLE PRECISION,
    shot_outcome TEXT,
    shot_body_part TEXT,
    shot_type TEXT,
    shot_technique TEXT,
    shot_first_time BOOLEAN,
    shot_one_on_one BOOLEAN,
    end_x DOUBLE PRECISION,
    end_y DOUBLE PRECISION,
    end_z DOUBLE PRECISION
);

