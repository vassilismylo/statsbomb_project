/* =========================================================
   02_create_facts_sqlserver.sql
   SQL Server + SSAS Multidimensional friendly facts
   ========================================================= */

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'fact') EXEC('CREATE SCHEMA fact');
GO

/* -------------------------
   Event fact
   Grain: 1 row per event (StatsBomb event_id)
   ------------------------- */
CREATE TABLE fact.fact_event (
    event_key            BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_fact_event PRIMARY KEY,

    event_id             NVARCHAR(64) NOT NULL, -- StatsBomb event id (text in your script)
    match_key            INT          NOT NULL,
    team_key             INT          NOT NULL,
    player_key           INT          NULL,

    period               SMALLINT     NULL,
    minute               SMALLINT     NULL,
    second               SMALLINT     NULL,

    event_type           NVARCHAR(100) NULL,
    event_category       NVARCHAR(100) NULL,

    possession           INT          NULL,
    possession_team_key  INT          NULL,

    under_pressure       BIT          NULL,

    x                    FLOAT        NULL,
    y                    FLOAT        NULL,

    is_pass              BIT          NULL,
    is_shot              BIT          NULL,
    is_pressure          BIT          NULL,
    is_carry BIT NULL,

    CONSTRAINT UQ_fact_event_event_id UNIQUE (event_id),

    CONSTRAINT FK_fact_event_match
        FOREIGN KEY (match_key) REFERENCES dim.dim_match(match_key),

    CONSTRAINT FK_fact_event_team
        FOREIGN KEY (team_key) REFERENCES dim.dim_team(team_key),

    CONSTRAINT FK_fact_event_player
        FOREIGN KEY (player_key) REFERENCES dim.dim_player(player_key),

    CONSTRAINT FK_fact_event_possession_team
        FOREIGN KEY (possession_team_key) REFERENCES dim.dim_team(team_key)
);
GO

CREATE INDEX IX_fact_event_match_key ON fact.fact_event(match_key);
CREATE INDEX IX_fact_event_team_key  ON fact.fact_event(team_key);
CREATE INDEX IX_fact_event_player_key ON fact.fact_event(player_key);
GO

/* -------------------------
   Shot fact
   Grain: 1 row per shot event
   This is a separate measure group (classic OLAP).
   ------------------------- */
CREATE TABLE fact.fact_shot (
    shot_key            BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT PK_fact_shot PRIMARY KEY,
    event_id            NVARCHAR(64) NOT NULL,
    event_key           BIGINT       NULL,      
    match_key           INT          NOT NULL,
    team_key            INT          NOT NULL,
    player_key          INT          NULL,

    shot_attr_key       INT          NULL,

    shot_statsbomb_xg   FLOAT        NULL,

    end_x               FLOAT        NULL,
    end_y               FLOAT        NULL,
    end_z               FLOAT        NULL,

    CONSTRAINT UQ_fact_shot_event_id UNIQUE (event_id),

    CONSTRAINT FK_fact_shot_match
        FOREIGN KEY (match_key) REFERENCES dim.dim_match(match_key),

    CONSTRAINT FK_fact_shot_team
        FOREIGN KEY (team_key) REFERENCES dim.dim_team(team_key),

    CONSTRAINT FK_fact_shot_player
        FOREIGN KEY (player_key) REFERENCES dim.dim_player(player_key),

    CONSTRAINT FK_fact_shot_attr
        FOREIGN KEY (shot_attr_key) REFERENCES dim.dim_shot_attributes(shot_attr_key),

    CONSTRAINT FK_fact_shot_eventkey
        FOREIGN KEY (event_key) REFERENCES fact.fact_event(event_key)
);
GO

CREATE INDEX IX_fact_shot_match_key ON fact.fact_shot(match_key);
CREATE INDEX IX_fact_shot_team_key  ON fact.fact_shot(team_key);
CREATE INDEX IX_fact_shot_player_key ON fact.fact_shot(player_key);
GO

CREATE TABLE statsbomb.fact.fact_pass (
    pass_key              BIGINT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_fact_pass PRIMARY KEY,

    event_id              NVARCHAR(64) NOT NULL,
    event_key             BIGINT       NULL,

    match_key             INT NOT NULL,
    team_key              INT NOT NULL,

    passer_player_key     INT NOT NULL,
    receiver_player_key   INT NULL,

    pass_attr_key         INT NOT NULL,

    end_x                 FLOAT NULL,
    end_y                 FLOAT NULL,
    pass_length           FLOAT NULL,
    pass_angle            FLOAT NULL,

    CONSTRAINT UQ_fact_pass_event_id UNIQUE (event_id),

    CONSTRAINT FK_fact_pass_event
        FOREIGN KEY (event_key) REFERENCES fact.fact_event(event_key),

    CONSTRAINT FK_fact_pass_match
        FOREIGN KEY (match_key) REFERENCES dim.dim_match(match_key),

    CONSTRAINT FK_fact_pass_team
        FOREIGN KEY (team_key) REFERENCES dim.dim_team(team_key),

    CONSTRAINT FK_fact_pass_passer
        FOREIGN KEY (passer_player_key) REFERENCES dim.dim_player(player_key),

    CONSTRAINT FK_fact_pass_receiver
        FOREIGN KEY (receiver_player_key) REFERENCES dim.dim_player(player_key),

    CONSTRAINT FK_fact_pass_attr
        FOREIGN KEY (pass_attr_key) REFERENCES dim.dim_pass_attributes(pass_attr_key)
);
GO



CREATE INDEX IX_fact_pass_match_key
    ON fact.fact_pass(match_key);

CREATE INDEX IX_fact_pass_team_key
    ON fact.fact_pass(team_key);

CREATE INDEX IX_fact_pass_passer_player_key
    ON fact.fact_pass(passer_player_key);

CREATE INDEX IX_fact_pass_receiver_player_key
    ON fact.fact_pass(receiver_player_key);

CREATE INDEX IX_fact_pass_event_key
    ON fact.fact_pass(event_key);

CREATE INDEX IX_fact_pass_attr_key
    ON fact.fact_pass(pass_attr_key);
GO
