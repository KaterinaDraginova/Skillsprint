-- Query finding total number of unique speakers who
-- conducted events in each country

SELECT 
    v.country,
    COUNT(DISTINCT se.speaker_id) AS unique_speakers
FROM sessions se
JOIN schedule sc
    ON se.session_id = sc.session_id
JOIN venues v
    ON v.venue_id = sc.venue_id
GROUP BY v.country;
