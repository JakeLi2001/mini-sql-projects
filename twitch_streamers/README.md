# Top Streamers on Twitch

## Data Source: [Top Streamers on Twitch](https://www.kaggle.com/datasets/aayushmishra1512/twitchdata)

This dataset is from Kaggle and it contains the top 1000 streamers/channels data from 2019.

Features:
- Channel: channel name 
- Watch time (minutes)
- Stream time (minutes)
- Peak viewers
- Average viewers
- Followers
- Followers gained: followers gained in 2019
- Views gained: views gained in 2019
- Partnered: twitch partnered or not
- Mature: 18+ Stream or not
- Language

## 5 Questions
1. What are the top 5 channels with the highest watch time descending?
2. Which channel has the highest stream time to watch time conversion rate? (In other words, how many watch time are generated per stream time in minutes)
3. Find the top 5 counts of channels per language.
4. What are the top 10 channels with the highest peak viewers and their gap in viewers to the previous channel?
5. Find the top 10 channels that gained the most followers in percentage with at least 1 million followers?

## Answers
1. xQcOW, summit1g, Gaules, ESL_CSGO, and Tfue have the highest watch time (minutes) in 2019.
![](results/Q1.png)
2. dota2ti has the highest conversion rate. Every minute of stream will generate about 161136 minutes of watch time.
![](results/Q2.png)
3. English, Korean, Russian, Spanish, and French are the most common languages by the top 1000 streamers/channels.
![](results/Q3.png)
4. Riot Games has the most peak viewers in 2019, and I believe it's due to the League of Legends world championship.
![](results/Q4.png)
5. These 10 streamers/channels gained the most followers in percentage in 2019.
![](results/Q5.png)

## Visualizations
[Tableau Public](https://public.tableau.com/views/TwitchStreamers2019/Top5ChannelswithMostWatchTimeminutes?:language=en-US&:display_count=n&:origin=viz_share_link)

<div class='tableauPlaceholder' id='viz1674501697627' style='position: relative'><noscript><a href='#'><img alt=' ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Tw&#47;TwitchStreamers2019&#47;Top5ChannelswithMostWatchTimeminutes&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='site_root' value='' /><param name='name' value='TwitchStreamers2019&#47;Top5ChannelswithMostWatchTimeminutes' /><param name='tabs' value='yes' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Tw&#47;TwitchStreamers2019&#47;Top5ChannelswithMostWatchTimeminutes&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='language' value='en-US' /></object></div>
