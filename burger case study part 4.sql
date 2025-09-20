CREATE TABLE runner_orders(
   order_id     INTEGER  NOT NULL PRIMARY KEY 
  ,runner_id    INTEGER  NOT NULL
  ,pickup_time  timestamp
  ,distance     VARCHAR(7)
  ,duration     VARCHAR(10)
  ,cancellation VARCHAR(23)
);
INSERT INTO runner_orders VALUES (1,1,'2021-01-01 18:15:34','20km','32 minutes',NULL);
INSERT INTO runner_orders VALUES (2,1,'2021-01-01 19:10:54','20km','27 minutes',NULL);
INSERT INTO runner_orders VALUES (3,1,'2021-01-03 00:12:37','13.4km','20 mins',NULL);
INSERT INTO runner_orders VALUES (4,2,'2021-01-04 13:53:03','23.4','40',NULL);
INSERT INTO runner_orders VALUES (5,3,'2021-01-08 21:10:57','10','15',NULL);
INSERT INTO runner_orders VALUES (6,3,NULL,NULL,NULL,'Restaurant Cancellation');
INSERT INTO runner_orders VALUES (7,2,'2021-01-08 21:30:45','25km','25mins',NULL);
INSERT INTO runner_orders VALUES (8,2,'2021-01-10 00:15:02','23.4 km','15 minute',NULL);
INSERT INTO runner_orders VALUES (9,2,NULL,NULL,NULL,'Customer Cancellation');
INSERT INTO runner_orders VALUES (10,1,'2021-01-11 18:50:20','10km','10minutes',NULL);
SELECT COUNT(*) AS NO_OF_ORERS
FROM runner_orders ;

select runner_id,
count(distinct order_id) as successful_orders
from runner_orders
where cancellation is null
group by runner_id 
order by successful_orders desc;

SELECT 
    p.burger_name,
    COUNT(c.burger_id) AS delivered_burger_count
FROM customer_orders AS c
JOIN runner_orders AS r
    ON c.order_id = r.order_id
JOIN burger_names AS p
    ON c.burger_id = p.burger_id
WHERE r.distance IS NOT NULL
GROUP BY p.burger_name
ORDER BY delivered_burger_count DESC; 

WITH burger_count_cte AS (
    SELECT 
        c.order_id,
        COUNT(c.burger_id) AS burger_per_order
    FROM customer_orders AS c
    JOIN runner_orders AS r 
        ON c.order_id = r.order_id
    WHERE r.distance IS NOT NULL 
          AND r.distance <>0
    GROUP BY c.order_id
)
SELECT MAX(burger_per_order) AS burger_count
FROM burger_count_cte;

--Q7
SELECT 
    c.customer_id,
    SUM(
        CASE 
            WHEN c.exclusions <> '' OR c.extras <> '' THEN 1
            ELSE 0
        END
    ) AS at_least_1_change,
    SUM(
        CASE 
            WHEN (c.exclusions = '' OR c.exclusions IS NULL)
             AND (c.extras = '' OR c.extras IS NULL) THEN 1
            ELSE 0
        END
    ) AS no_change
FROM customer_orders AS c
JOIN runner_orders AS r 
    ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL 
  AND r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;

select extract (hour from order_time)as hour_of_day,
count(order_id)as burger_count
from customer_orders
group by extract(hour from order_time);

select extract (week from registration_date)
as registration_week,
count(runner_id)as runner_signup
from burger_runner
group by extract(week from registration_date);



SELECT 
    c.customer_id,
    AVG(r.distance) AS avg_distance
FROM customer_orders AS c
JOIN runner_orders AS r
    ON c.order_id = r.order_id
WHERE r.duration IS NOT NULL
  AND r.duration != 0
GROUP BY c.customer_id
ORDER BY c.customer_id;













