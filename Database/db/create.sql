
CREATE TABLE raw_player_stats (
    player_name TEXT,
    player_number TEXT,
    position TEXT,
    height TEXT,
    weight TEXT,
    birth_year TEXT,
    hometown TEXT,
    home_state TEXT,
    school TEXT,
    passing_yards TEXT,
    passing_comp TEXT,
    passing_att TEXT,
    passing_pct TEXT,
    passing_td TEXT,
    passing_int TEXT,
    passing_long TEXT,
    passing_rating TEXT,
    rushing_yards TEXT,
    rushing_carries TEXT,
    rushing_long TEXT,
    rushing_td TEXT,
    receiving_yards TEXT,
    receiving_rec TEXT,
    receiving_long TEXT,
    receiving_td TEXT,
    tackles_solo TEXT,
    tackles_assists TEXT,
    tackles_for_loss TEXT,
    sacks TEXT,
    forced_fumbles TEXT,
    interceptions TEXT,
    interception_return_yards TEXT,
    interception_return_long TEXT,
    interception_return_td TEXT,
    fumble_recoveries TEXT,
    fumble_return_yards TEXT,
    fumble_return_long TEXT,
    fumble_return_td TEXT,
    pass_deflections TEXT,
    blocked_kicks_and_punts TEXT,
    kickoff_returns TEXT,
    kickoff_returns_yards TEXT,
    kickoff_returns_long TEXT,
    kickoff_returns_td TEXT,
    punt_returns TEXT,
    punt_return_yards TEXT,
    punt_return_long TEXT,
    punt_return_td TEXT,
    punts TEXT,
    punting_yards TEXT,
    punting_touchbacks TEXT,
    punting_long TEXT,
    touchdowns TEXT,
    field_goals TEXT,
    field_goal_att TEXT,
    field_goal_long TEXT,
    pat_kicks TEXT,
    pat_kicks_att TEXT,
    safeties TEXT,
    pat_conversions TEXT
);

CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    division VARCHAR(50),
    owner VARCHAR(100),
    titles INT DEFAULT 0,
    tv_tag VARCHAR(20)
);

CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    dob DATE,
    height VARCHAR(10),
    weight INT,
    war NUMERIC(6,2),
    UNIQUE (full_name, dob)
);


CREATE TABLE player_team_seasons (
    player_team_season_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES players(player_id) ON DELETE CASCADE,
    team_id INT NOT NULL REFERENCES teams(team_id) ON DELETE CASCADE,
    season INT NOT NULL,
    jersey_number INT,
    role_group VARCHAR(20), -- Offensive / Defense / ST
    UNIQUE (player_id, team_id, season)
);


CREATE TABLE games (
    game_id SERIAL PRIMARY KEY,
    week INT,
    game_datetime TIMESTAMP,
    venue VARCHAR(150),
    game_type VARCHAR(30) -- regular, playoff, etc.
);


CREATE TABLE team_games (
    team_game_id SERIAL PRIMARY KEY,
    game_id INT NOT NULL REFERENCES games(game_id) ON DELETE CASCADE,
    team_id INT NOT NULL REFERENCES teams(team_id) ON DELETE CASCADE,
    home_or_away VARCHAR(10) CHECK (home_or_away IN ('home', 'away')),
    score INT DEFAULT 0,
    UNIQUE (game_id, team_id)
);


CREATE TABLE player_game_appearances (
    player_game_id SERIAL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES players(player_id) ON DELETE CASCADE,
    game_id INT NOT NULL REFERENCES games(game_id) ON DELETE CASCADE,
    team_id INT NOT NULL REFERENCES teams(team_id) ON DELETE CASCADE,
    season INT,
    UNIQUE (player_id, game_id)
);


CREATE TABLE coaches (
    coach_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    dob DATE,
    record VARCHAR(50)
);


CREATE TABLE coach_team_seasons (
    coach_team_season_id SERIAL PRIMARY KEY,
    coach_id INT NOT NULL REFERENCES coaches(coach_id) ON DELETE CASCADE,
    team_id INT NOT NULL REFERENCES teams(team_id) ON DELETE CASCADE,
    season INT NOT NULL,
    title VARCHAR(50), -- head coach, assistant, etc.
    UNIQUE (coach_id, team_id, season, title)
);

CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    job_title VARCHAR(100),
    dob DATE
);


CREATE TABLE staff_team_seasons (
    staff_team_season_id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL REFERENCES staff(staff_id) ON DELETE CASCADE,
    team_id INT NOT NULL REFERENCES teams(team_id) ON DELETE CASCADE,
    season INT NOT NULL,
    UNIQUE (staff_id, team_id, season)
);


CREATE TABLE trades (
    trade_id SERIAL PRIMARY KEY,
    team_from_id INT NOT NULL REFERENCES teams(team_id),
    team_to_id INT NOT NULL REFERENCES teams(team_id),
    trade_date DATE NOT NULL,
    cash_amount NUMERIC(12,2) DEFAULT 0,
    CHECK (team_from_id <> team_to_id)
);


CREATE TABLE trade_players (
    trade_player_id SERIAL PRIMARY KEY,
    trade_id INT NOT NULL REFERENCES trades(trade_id) ON DELETE CASCADE,
    player_id INT NOT NULL REFERENCES players(player_id) ON DELETE CASCADE,
    from_team_id INT NOT NULL REFERENCES teams(team_id),
    to_team_id INT NOT NULL REFERENCES teams(team_id)
);

CREATE TABLE passing_stats (
    player_game_id INT PRIMARY KEY REFERENCES player_game_appearances(player_game_id) ON DELETE CASCADE,
    pass_attempts INT DEFAULT 0,
    pass_completions INT DEFAULT 0,
    pass_yards INT DEFAULT 0,
    pass_touchdowns INT DEFAULT 0,
    interceptions_thrown INT DEFAULT 0
);

CREATE TABLE rushing_stats (
    player_game_id INT PRIMARY KEY REFERENCES player_game_appearances(player_game_id) ON DELETE CASCADE,
    rush_attempts INT DEFAULT 0,
    rush_yards INT DEFAULT 0,
    rush_touchdowns INT DEFAULT 0,
    longest_rush INT DEFAULT 0
);

CREATE TABLE receiving_stats (
    player_game_id INT PRIMARY KEY REFERENCES player_game_appearances(player_game_id) ON DELETE CASCADE,
    receptions INT DEFAULT 0,
    receiving_yards INT DEFAULT 0,
    receiving_touchdowns INT DEFAULT 0,
    longest_reception INT DEFAULT 0
);

CREATE TABLE special_teams_stats (
    player_game_id INT PRIMARY KEY REFERENCES player_game_appearances(player_game_id) ON DELETE CASCADE,
    kick_returns INT DEFAULT 0,
    kick_return_yards INT DEFAULT 0,
    punt_returns INT DEFAULT 0,
    punt_return_yards INT DEFAULT 0,
    field_goals_made INT DEFAULT 0,
    field_goals_attempted INT DEFAULT 0,
    extra_points_made INT DEFAULT 0,
    punts INT DEFAULT 0,
    punt_yards INT DEFAULT 0,
    st_points INT DEFAULT 0
);