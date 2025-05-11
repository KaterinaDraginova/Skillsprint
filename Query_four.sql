-- Query finding the trend of events
-- by calculating the total number of attendees who registered for events in each country

SELECT 
    v.country,
    COUNT(*) AS number_of_registrations
FROM schedule sc
JOIN registrations reg
    ON reg.event_id = sc.event_id
JOIN venues v
    ON v.venue_id = sc.venue_id
GROUP BY v.country;
