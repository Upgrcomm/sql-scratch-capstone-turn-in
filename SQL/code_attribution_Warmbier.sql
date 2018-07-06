

/*
1_Here's the distinct campaigns
*/
SELECT DISTINCT utm_campaign AS source
	FROM page_visits;


/*
1_Here's the distinct sources
*/
SELECT DISTINCT utm_source AS source
	FROM page_visits;


/*
1_Here's the number of distinct campaigns and sources
*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT COUNT(DISTINCT pv.utm_source),
		COUNT (DISTINCT pv.utm_campaign),
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp;



/*
2_Here's the distinct page names for the page visits table
*/
SELECT DISTINCT page_name
		FROM page_visits;



/*
3_Here's the first_touches for each campaign 
*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
SELECT ft.user_id,
       ft.first_touch_at,
       pv.utm_source,
       pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
  )
  SELECT ft_attr.utm_source as source,
       ft_attr.utm_campaign as campaign,
       COUNT(*) as first_touches
FROM ft_attr
GROUP BY 1, 2;



/*
4_Here's the last touches for each campaign
*/
WITH last_touch AS (
  SELECT user_id,
       MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source as source,
       lt_attr.utm_campaign as campaign,
       COUNT(*) as last_touch
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;



/*
5_Here's how many visitors made a purchase
*/
SELECT COUNT(DISTINCT user_id) as visitors_purchase
 FROM page_visits
  WHERE page_name = '4 - purchase';


/*
6_Here's how many last touches on the purchase page for each campaign 
*/
WITH last_touch AS (
  SELECT user_id,
         MAX(timestamp) AS last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;




