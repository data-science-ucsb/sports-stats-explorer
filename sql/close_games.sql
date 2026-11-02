WITH team_game_results AS (

    -- Home team's perspective
    SELECT
        home_team_id AS team_id,
        home_score AS points_for,
        away_score AS points_against
    FROM games
    WHERE ABS(home_score - away_score) <= :margin

    UNION ALL

    -- Away team's perspective
    SELECT
        away_team_id AS team_id,
        away_score AS points_for,
        home_score AS points_against
    FROM games
    WHERE ABS(home_score - away_score) <= :margin
)

SELECT
    t.abbreviation AS team,

    COUNT(r.team_id) AS close_games,

    SUM(
        CASE
            WHEN r.points_for > r.points_against THEN 1
            ELSE 0
        END
    ) AS close_wins,

    SUM(
        CASE
            WHEN r.points_for < r.points_against THEN 1
            ELSE 0
        END
    ) AS close_losses,

    CASE
        WHEN COUNT(r.team_id) = 0 THEN NULL
        ELSE ROUND(
            1.0 * SUM(
                CASE
                    WHEN r.points_for > r.points_against THEN 1
                    ELSE 0
                END
            ) / COUNT(r.team_id),
            3
        )
    END AS close_win_pct

FROM teams t

LEFT JOIN team_game_results r
    ON t.team_id = r.team_id

GROUP BY t.team_id, t.abbreviation

ORDER BY close_win_pct DESC;