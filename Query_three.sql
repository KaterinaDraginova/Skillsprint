-- Query finding the capacity of the venue that
-- hosted the second-highest number of sessions
-- of a specific type. In this case, the session type is Webinar

WITH top_webinar_hosts AS (
    SELECT
        sc.venue_id,
        COUNT(*) AS hosted_times,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM sessions se
    JOIN schedule sc
        ON se.session_id = sc.session_id
    WHERE se.session_type = 'Webinar'
    GROUP BY sc.venue_id
)

SELECT v.capacity
FROM top_webinar_hosts twh
JOIN venues v
    ON twh.venue_id = v.venue_id
WHERE twh.rn = 2;
