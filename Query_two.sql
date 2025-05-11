-- Query displaying the most popular speaker (based on highest average Rating) 
-- at each Venue using CTE and a window function for clearer implementation


WITH avg_venues_rating AS (
  SELECT 
    sc.session_id,
    sc.venue_id,
    AVG(rev.rating) AS avg_rating
  FROM registrations reg
  JOIN reviews rev
    ON rev.registration_id = reg.registration_id
  JOIN schedule sc
    ON sc.event_id = reg.event_id
  GROUP BY sc.session_id, sc.venue_id
),
ranked_venues AS (
  SELECT 
    s.session_id,
    avr.venue_id,
    avr.avg_rating,
    sp.speaker_id,
    CONCAT(sp.first_name, ' ', sp.last_name) AS speaker_name,
    RANK() OVER (PARTITION BY avr.venue_id ORDER BY avr.avg_rating DESC) AS first_rank
  FROM avg_venues_rating avr
  JOIN sessions s
    ON avr.session_id = s.session_id
  JOIN speakers sp
    ON sp.speaker_id = s.speaker_id
)

SELECT  
  rv.speaker_name,
  v.name AS venue_name,
  rv.avg_rating
FROM ranked_venues rv
JOIN venues v
  ON v.venue_id = rv.venue_id
WHERE rv.first_rank = 1;
