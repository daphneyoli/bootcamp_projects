-- Challenge Sample Scenarios --

/*SELECT * FROM artist 
SELECT * FROM album*/

-- Create a joined table from the Artist and Album tables and order it by Name and Title --

SELECT *, a2.Name, a.Title
FROM Album a 
JOIN Artist a2 
ON a.artistid = a2.artistid
ORDER BY Name, Title
;

-- Using the table created above make a table that contains Name, Title 
-- and a distinct TableID number for every record in the table

WITH MusicID AS 
(
SELECT a2.Name, a.Title, 
ROW_NUMBER () OVER() AS TableID
FROM Album a 
JOIN Artist a2 
ON a.artistid = a2.artistid
ORDER BY a2.Name, a.Title
)
SELECT TableID, Name, Title
FROM MusicID
ORDER BY TableID ASC
;

-- Add a column called album rank that ranks each album,
-- windowed by Name creating an album rank for each band

WITH MusicID AS 
(
SELECT a2.Name, a.Title, 
ROW_NUMBER () OVER() AS TableID,
RANK() OVER (PARTITION BY a2.Name ORDER BY a.Title) AS AlbumRank
FROM Album a 
JOIN Artist a2 
ON a.artistid = a2.artistid
ORDER BY a2.Name, a.Title
)
SELECT TableID, Name, Title, AlbumRank
FROM MusicID
ORDER BY TableID ASC
;

-- Part 2: Lag --
-- Create a table that contains the TrackID, Name, AlbumId and Milliseconds from AlbumId = 13 ordered by TrackID --

/*SELECT * FROM album 
SELECT * FROM track*/

WITH AlbumThirteen AS 
(
SELECT t.TrackID, t.Name, a.AlbumID, t.Milliseconds
FROM Album a
JOIN track t
ON t.albumId = a.AlbumId 
WHERE a.albumID = 13
)
SELECT TrackID, Name, AlbumID, Milliseconds
FROM AlbumThirteen
ORDER BY TrackID ASC
;

-- Create a column of Milliseconds lagged by 1 row --

WITH AlbumThirteen AS 
(
SELECT t.TrackID, t.Name, a.AlbumID, t.Milliseconds, 
LAG(t.Milliseconds) OVER () AS LagMilliseconds
FROM Album a
JOIN track t
ON t.albumId = a.AlbumId 
WHERE a.albumID = 13
)
SELECT * 
FROM AlbumThirteen
ORDER BY TrackID ASC 
;

-- Create a table that subtracts Milliseconds from LagMilliseconds from the table above 
-- to compare the length of consecutive songs on the album

WITH AlbumThirteen AS 
(
SELECT t.TrackID, t.Name, a.AlbumID, t.Milliseconds, 
LAG(t.Milliseconds) OVER () AS LagMilliseconds
FROM Album a
JOIN track t
ON t.albumId = a.AlbumId 
WHERE a.albumID = 13
)
SELECT *, LagMilliseconds - Milliseconds  AS DiffMilliseconds
FROM AlbumThirteen
;