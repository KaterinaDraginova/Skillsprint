-- Query displaying the first name
-- and last name of a speaker, the first and
-- last name of an attendee, and the total number
-- of sessions the attendee attended with that speaker,
-- but only for attendees who attended more than one session given by the speaker



WITH result AS (
    SELECT 
        reg.event_id,
        ses.speaker_id,
        reg.attendee_id
    FROM schedule sc 
    JOIN registrations reg
        ON reg.event_id = sc.event_id
    JOIN sessions ses
        ON ses.session_id = sc.session_id
),
result_one AS (
    SELECT 
        attendee_id,
        speaker_id,
        COUNT(*) AS number_of_sessions
    FROM result
    GROUP BY attendee_id, speaker_id
    HAVING COUNT(*) > 1
)

SELECT 
    sp.first_name AS speaker_first_name,
    sp.last_name AS speaker_last_name,
    att.first_name AS attendee_first_name,
    att.last_name AS attendee_last_name,
    ro.number_of_sessions
FROM result_one ro
JOIN attendees att
    ON att.attendee_id = ro.attendee_id 
JOIN speakers sp
    ON sp.speaker_id = ro.speaker_id;
