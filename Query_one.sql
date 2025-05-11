-- Update to make titles easier to observe based on the speaker's area of expertise

UPDATE sessions 
SET sessions.title = sessions.title + ' (' + speakers.expertise_area + ')'
FROM sessions 
JOIN speakers ON sessions.speaker_id = speakers.speaker_id;
