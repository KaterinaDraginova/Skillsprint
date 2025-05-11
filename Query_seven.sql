-- Query finding the total number of events held in each venue

WITH event_counter AS (
    SELECT
        venue_id,
        COUNT(*) AS number_of_events
    FROM schedule
    GROUP BY venue_id
)

SELECT 
    v.venue_id,
    v.country,
    ec.number_of_events
FROM venues v
JOIN event_counter ec
    ON v.venue_id = ec.venue_id;
