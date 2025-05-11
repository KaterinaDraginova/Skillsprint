-- Query displaying the 3 sessions
-- that have received the highest ratings from
-- young Attendees (under 25 years old). Only include
-- events that happened in specific country (in my case Portugal).
-- The output shows session's title, the speaker's full name, and the average rating from young attendees.


WITH result_one AS (
    SELECT 
        sc.session_id,
        AVG(rev.rating) AS avg_rating
    FROM attendees att
    JOIN registrations reg
        ON att.attendee_id = reg.attendee_id
    JOIN reviews rev
        ON rev.registration_id = reg.registration_id
    JOIN schedule sc
        ON sc.event_id = reg.event_id
    JOIN venues v
        ON v.venue_id = sc.venue_id
    WHERE DATEDIFF(YEAR, att.dob, reg.registration_date) < 25
      AND v.country = 'Portugal'
    GROUP BY sc.session_id
)
SELECT TOP 3 
    ses.title,
    sp.first_name + ' ' + sp.last_name AS speaker_full_name,
    ro.avg_rating
FROM result_one ro
JOIN sessions ses
    ON ses.session_id = ro.session_id
JOIN speakers sp
    ON sp.speaker_id = ses.speaker_id
ORDER BY ro.avg_rating DESC;
