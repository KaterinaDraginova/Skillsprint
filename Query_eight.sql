-- Average rating for all sessions, based on attendee reviews for each country

WITH result_one AS (
    SELECT 
        reg.registration_id,
        reg.attendee_id,
        reg.event_id,
        rev.review_id,
        sc.session_id,
        rev.rating
    FROM registrations reg
    JOIN reviews rev
        ON rev.registration_id = reg.registration_id
    JOIN schedule sc
        ON sc.event_id = reg.event_id
)

SELECT 
    sc.session_id,
    v.country,
    ses.title,
    AVG(ro.rating) AS avg_rating
FROM result_one ro
JOIN schedule sc
    ON sc.session_id = ro.session_id
JOIN venues v
    ON v.venue_id = sc.venue_id
JOIN sessions ses
    ON ses.session_id = sc.session_id
GROUP BY v.country, sc.session_id, ses.title;
