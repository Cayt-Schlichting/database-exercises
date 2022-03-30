#Cayt Schlichting

USE albums_db;
DESCRIBE albums;
SELECT * FROM albums; #31 rows
SELECT DISTINCT artist FROM albums; #23 distinct artisits
# 'id' is primary key
# Oldest release date is 1967 - used sort on previous query
# Most recent release date is 2011 - used sort on previous query
SELECT name FROM albums WHERE artist = 'Pink Floyd'; #4a
SELECT release_date FROM albums WHERE name = 'Sgt. Pepper''s Lonely Hearts Club Band'; #4b
SELECT genre FROM albums WHERE name = 'Nevermind'; #4c
SELECT * FROM albums WHERE (release_date >= 1990 AND release_date < 2000); #4d 
SELECT * FROM albums WHERE sales <= 20; #4e - ugh, no metadata indicating sales are in millions
SELECT * FROM albums WHERE genre = 'Rock'; #4f - it's looking for an exact string match, so won't include 'hard rock'
-- SELECT * FROM albums WHERE genre LIKE '%Rock%'; #playing around with contains substring options



