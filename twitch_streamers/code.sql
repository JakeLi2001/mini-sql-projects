-- create table
CREATE TABLE IF NOT EXISTS twitch_streamers (
    channel VARCHAR(50) PRIMARY KEY,
    watch_time_in_minutes BIGINT,
    stream_time_in_minutes BIGINT,
    peak_viewers INT,
    average_viewers INT,
    followers INT,
    followers_gained INT,
    views_gained INT,
    partnered BOOL,
    mature BOOL, 
    language VARCHAR(30)
);
-- SET CLIENT_ENCODING TO 'utf8';
-- import data
\COPY twitch_streamers FROM 'PATH' DELIMITER ',' CSV HEADER;



-- 1) What are the top 5 channel with the highest watch time descending?
SELECT channel, watch_time_in_minutes
FROM twitch_streamers
ORDER BY watch_time_in_minutes DESC
LIMIT 5; 

-- 2. Which channel has the highest stream time to watch time conversion rate? (In other words, how many watch time generated per stream time in minutes)
SELECT channel, average_viewers, (watch_time_in_minutes / stream_time_in_minutes) AS conversion_rate
FROM twitch_streamers
ORDER BY conversion_rate DESC
LIMIT 1;

-- 3. Find the top 5 count of channels per language.
SELECT language, COUNT(language) AS count
FROM twitch_streamers
GROUP BY language
ORDER BY count DESC
LIMIT 5;

-- 4. What are the top 10 channels with the highest peak viewers and their gap in viewers to the previous channel?
SELECT channel, peak_viewers, (LAG(peak_viewers, 1) OVER (ORDER BY peak_viewers DESC) - peak_viewers) AS difference_to_previous
FROM twitch_streamers
ORDER BY peak_viewers DESC
LIMIT 10;

-- 5. Find top 20 channels that gained the most followers in percentage with at least 1 million followers?
SELECT channel, followers, followers_gained, ROUND(followers_gained::decimal / followers, 2) AS followers_percentage_increase
FROM twitch_streamers
WHERE followers >= 1000000
ORDER BY followers_percentage_increase DESC
LIMIT 10;