-- =============================================================
-- League summary
--
-- Question: How many teams, players, and games are in the league?
--
-- Returns:   n_teams, n_players, n_games
-- =============================================================

SELECT
    (SELECT COUNT(*) FROM teams)   AS n_teams,
    (SELECT COUNT(*) FROM players) AS n_players,
    (SELECT COUNT(*) FROM games)   AS n_games;
