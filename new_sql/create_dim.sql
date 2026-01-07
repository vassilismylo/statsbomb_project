/* =========================================================
   01_create_dimensions_sqlserver.sql
   SQL Server + SSAS Multidimensional friendly dimensions
   ========================================================= */

-- Create schemas (SQL Server style)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dim') EXEC('CREATE SCHEMA dim');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'fact') EXEC('CREATE SCHEMA fact');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'agg') EXEC('CREATE SCHEMA agg');
GO

/* -------------------------
   Core dimensions
   ------------------------- */

CREATE TABLE dim.dim_team (
    team_key   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_dim_team PRIMARY KEY,
    team_id    INT               NOT NULL,  -- StatsBomb natural id
    team_name  NVARCHAR(200)     NOT NULL,
    CONSTRAINT UQ_dim_team_team_id UNIQUE (team_id)
);
GO

CREATE TABLE dim.dim_player (
    player_key    INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_dim_player PRIMARY KEY,
    player_id     INT               NOT NULL,  -- StatsBomb natural id
    player_name   NVARCHAR(200)     NOT NULL,
    position_name NVARCHAR(100)     NULL,
    CONSTRAINT UQ_dim_player_player_id UNIQUE (player_id)
);
GO

CREATE TABLE dim.dim_competition (
    competition_key  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_dim_competition PRIMARY KEY,
    competition_id   INT               NOT NULL,  -- StatsBomb natural id
    competition_name NVARCHAR(200)     NOT NULL,
    country_name     NVARCHAR(100)     NULL,
    CONSTRAINT UQ_dim_competition_competition_id UNIQUE (competition_id)
);
GO

CREATE TABLE dim.dim_season (
    season_key  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_dim_season PRIMARY KEY,
    season_id   INT               NOT NULL,  -- StatsBomb natural id
    season_name NVARCHAR(100)     NOT NULL,
    CONSTRAINT UQ_dim_season_season_id UNIQUE (season_id)
);
GO

/* -------------------------
   Match dimension
   - Star-schema friendly: match has keys to teams/competition/season
   ------------------------- */
CREATE TABLE dim.dim_match (
    match_key        INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_dim_match PRIMARY KEY,
    match_id         INT               NOT NULL, -- StatsBomb natural id
    match_date       DATE              NULL,

    competition_key  INT               NULL,
    season_key       INT               NULL,

    home_team_key    INT               NULL,
    away_team_key    INT               NULL,

    home_team_name   NVARCHAR(200)     NULL,
    away_team_name   NVARCHAR(200)     NULL,

    home_score       INT               NULL,
    away_score       INT               NULL,
    match_week       INT               NULL,
    kick_off TIME NULL,

    CONSTRAINT UQ_dim_match_match_id UNIQUE (match_id),

    CONSTRAINT FK_dim_match_competition
        FOREIGN KEY (competition_key) REFERENCES dim.dim_competition(competition_key),

    CONSTRAINT FK_dim_match_season
        FOREIGN KEY (season_key) REFERENCES dim.dim_season(season_key),

    CONSTRAINT FK_dim_match_home_team
        FOREIGN KEY (home_team_key) REFERENCES dim.dim_team(team_key),

    CONSTRAINT FK_dim_match_away_team
        FOREIGN KEY (away_team_key) REFERENCES dim.dim_team(team_key)
);
GO

/* -------------------------
   Shot attributes dimension
   - This is classic OLAP: descriptive attributes in a dimension,
     measures in the fact.
   ------------------------- */
CREATE TABLE dim.dim_shot_attributes (
    shot_attr_key    INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_dim_shot_attributes PRIMARY KEY,

    shot_outcome     NVARCHAR(100) NULL,
    shot_body_part   NVARCHAR(100) NULL,
    shot_type        NVARCHAR(100) NULL,
    shot_technique   NVARCHAR(100) NULL,

    shot_first_time  BIT NULL,
    shot_one_on_one  BIT NULL
);
GO

CREATE TABLE dim.dim_pass_attributes (
    pass_attr_key   INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_dim_pass_attributes PRIMARY KEY,

    pass_height     NVARCHAR(50)  NULL,
    pass_type       NVARCHAR(100) NULL,
    pass_outcome    NVARCHAR(100) NULL
);
GO


/* -------------------------
   (Optional but recommended) Time dimension
   SSAS likes a real date dimension for hierarchies.
   You can populate it later.
   ------------------------- */
CREATE TABLE dim.dim_date (
    date_key     INT NOT NULL CONSTRAINT PK_dim_date PRIMARY KEY,   -- yyyymmdd
    [date]       DATE NOT NULL,
    [year]       INT  NOT NULL,
    [month]      INT  NOT NULL,
    [day]        INT  NOT NULL,
    month_name   NVARCHAR(20) NOT NULL,
    quarter_num  INT  NOT NULL
);
GO
