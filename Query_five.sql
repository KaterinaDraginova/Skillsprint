-- Query to find the trend of events by calculating the average number
-- of attendees who registered for events in each country

SELECT 
    v.country,
    ROUND(COUNT(reg.registration_id) * 1.0 / COUNT(DISTINCT sc.event_id), 2) AS avg_registrations
FROM registrations reg
JOIN schedule sc
    ON reg.event_id = sc.event_id
JOIN venues v
    ON v.venue_id = sc.venue_id
GROUP BY v.country;
