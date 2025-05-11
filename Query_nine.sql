-- Query displaying the top 3 Speakers (based on rating average)
-- who have conducted multiple events, that, on average, have a rating above
-- 2.75 and have an average of at least 10 attendees per event.


WITH distint_session_title AS (
    SELECT DISTINCT ses.title,
                    ses.speaker_id
    FROM schedule sc
    JOIN registrations reg
        ON sc.event_id = reg.event_id
    JOIN sessions ses
        ON ses.session_id = sc.session_id
),
distinct_events AS (
    SELECT speaker_id, 
           COUNT(DISTINCT sc.event_id) AS types_of_events
    FROM schedule sc
    JOIN sessions ses
        ON ses.session_id = sc.session_id
    GROUP BY speaker_id
    HAVING COUNT(DISTINCT sc.event_id) > 1
),
attendees_per_event AS (
    SELECT reg.event_id,
           COUNT(DISTINCT reg.registration_id) AS attendees
    FROM registrations reg
    LEFT JOIN reviews rev
        ON reg.registration_id = rev.registration_id
    JOIN schedule sc
        ON sc.event_id = reg.event_id
    JOIN sessions ses
        ON ses.session_id = sc.session_id
    JOIN speakers sp
        ON sp.speaker_id = ses.speaker_id
    GROUP BY sc.event_id
    HAVING COUNT(DISTINCT reg.registration_id) >= 10
),
avg_event_rating AS (
    SELECT sc.event_id,
           AVG(rev.rating) AS avg_rating
    FROM registrations reg
    JOIN reviews rev
        ON reg.registration_id = rev.registration_id
    JOIN schedule sc
        ON sc.event_id = reg.event_id
    JOIN sessions ses
        ON ses.session_id = sc.session_id
    JOIN speakers sp
        ON sp.speaker_id = ses.speaker_id
    GROUP BY sc.event_id
    HAVING AVG(rev.rating) > 2.75
)

SELECT TOP 3 
    sp.first_name,
    sp.last_name
FROM attendees_per_event ape
JOIN avg_event_rating aer
    ON ape.event_id = aer.event_id
JOIN schedule sc
    ON sc.event_id = aer.event_id
JOIN sessions ses
    ON ses.session_id = sc.session_id
JOIN speakers sp
    ON sp.speaker_id = ses.speaker_id
ORDER BY aer.avg_rating DESC;
