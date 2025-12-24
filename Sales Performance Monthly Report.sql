-- Query 1
SELECT SUM(qty) AS total_quantity_sold FROM balanced_tree.sales;
-- Output (1 row)
-- Total_quantity_sold
-- 45216

-- Query 2
-- What is the total generated revenue for all products before disCOUNTs?
SELECT SUM(qty*price) AS total_revenue
FROM balanced_tree.sales;
-- Output (1 row)
-- Total_before_disCOUNT
-- 1289453

-- Query 3
-- What wAS the total disCOUNT amount for all products?
SELECT SUM(qty*price*disCOUNT/100.0) AS total_disCOUNT
FROM balanced_tree.sales;
-- Output (1 row) 
-- total_disCOUNT
--- 156229.140

-- Query 4
-- How many unique transactiONs were there?
SELECT COUNT(DISTINCT txn_id) AS num_unique_trans
FROM balanced_tree.sales;
-- Output (1 row)
-- num_unique_trans
-- 2500

-- Query 5
-- What is the average unique products purchASed in each transactiON?
SELECT COUNT(*)*1.0/COUNT(DISTINCT txn_id) AS average_unique_prod_per_tnx
FROM balanced_tree.sales;
-- Output (1 row)
-- average_unique_prod_per_tnx
-- 6.0380

-- Query 6
-- What are the 25th, 50th and 75th percentile values for the revenue per transactiON?
WITH cte AS (SELECT SUM(qty*price*((100-disCOUNT)/100.0)) AS revenue_txn,
txn_id 
FROM balanced_tree.sales
GROUP by txn_id)

SELECT percentile_cont(0.25) WITHIN GROUP (ORDER BY revenue_txn ASC) AS first_percentile,
percentile_cont(0.5) WITHIN GROUP (ORDER BY revenue_txn ASC) AS second_percentile,
percentile_cont(0.75) WITHIN GROUP (ORDER BY revenue_txn ASC) AS third_percentile FROM cte;
-- Output (1 row)
-- first_percentile | secONd_percentile | third_percentile
-- 326.405          | 44`.225             | 572.7625

-- Query 7
-- What is the average disCOUNT value per transactiON?
WITH cte AS (SELECT SUM(qty*price*disCOUNT/100.0) AS discount_txn, txn_id from balanced_tree.sales
GROUP BY txn_id)

SELECT SUM(disCOUNT_txn)/COUNT(*) AS average_dis FROM cte;
-- Output (1 row)
-- average_dis
-- 62.49165600

-- Query 8
-- What is the percentage split of all transactiONs for members vs nON-members?
SELECT (SELECT COUNT(DISTINCT txn_id)*1.0/(SELECT COUNT(DISTINCT txn_id) FROM balanced_tree.sales) 
FROM balanced_tree.sales
WHERE member = 't') AS percent_member_tnx,
(SELECT COUNT(DISTINCT txn_id)*1.0/(SELECT COUNT(DISTINCT txn_id) FROM balanced_tree.sales) 
FROM balanced_tree.sales
where member = 'f') AS percent_nomember_tnx;
-- Output (1 row)
-- percent_member_tnx   | percent_nomember_tnx
-- 0.602                | 0.398

-- Query 9
-- What is the average revenue for member transactiONs and nON-member transactiONs?
WITH cte_member AS (SELECT SUM(qty*price*(1-disCOUNT/100.0)) AS tnx_revenue, 
txn_id
FROM balanced_tree.sales
WHERE member = 't'
GROUP by txn_id), 
cte_nomember AS (SELECT SUM(qty*price*(1-disCOUNT/100.0)) AS tnx_revenue, 
txn_id 
FROM balanced_tree.sales 
WHERE member = 'f' 
GROUP BY txn_id)

SELECT (SELECT SUM(tnx_revenue)*1.0/COUNT(*) AS member_avg_txn_revenue FROM cte_member),
 (SELECT SUM(tnx_revenue)*1.0/COUNT(*) AS nomember_avg_txn_revenue FROM cte_nomember);

-- Output (1 row)
-- member_avg_txn_revenue | nomember_avg_txn
-- 454.1369               | 452.0078

-- Query 10
-- What are the top 3 products by total revenue before disCOUNT?
SELECT s1.prod_id, 
SUM(s1.price*s1.qty) AS revenue, 
s2.product_name FROM balanced_tree.sales s1
JOIN balanced_tree.product_details s2 ON s1.prod_id=s2.product_id
GROUP BY prod_id, product_name
ORDER BY prod_id DESC 
LIMIT 3;
-- Output (3 rows)
-- prod_id      | revenue       | product_name
-- f084eb       | 136512        | Navy Solid Socks - Mens
-- e83aa3       | 121152        | Black Straight Jeans - Womens
-- e31d39       | 37070         | Cream Relaxed Jeans - Womens

-- Query 11
-- What is the total quantity, revenue and disCOUNT for each segment?
SELECT  s2.segment_name, 
SUM(s1.qty) AS quantity, 
SUM(s1.price*s1.qty) AS revenue, 
round(SUM(s1.price*s1.qty*s1.disCOUNT/100.0),2) AS disCOUNT
FROM balanced_tree.sales s1 
JOIN balanced_tree.product_details s2 ON s1.prod_id=s2.product_id
GROUP BY s2.segment_name;
-- Output (4 rows)
-- segment_name     | quantity      | revenue      | disCOUNT
-- Shirt            | 11265         | 406143       | 49594.27
-- Jeans            | 11349         | 208350       | 25343.97
-- Jacket           | 11385         | 366983       | 44277.46
-- Socks            | 11217         | 307977       | 37013.44

-- Query 12
-- What is the top selling product for each segment?
WITH cte AS (SELECT SUM(qty) AS quantity,
s2.segment_name, 
s2.product_name 
FROM balanced_tree.sales s1 
JOIN balanced_tree.product_details s2 ON s1.prod_id=s2.product_id
GROUP BY s2.segment_name, s2.product_name
ORDER BY segment_name, quantity desc), 
cte2 AS (SELECT *, 
RANK() OVER(PARTITION BY segment_name ORDER BY quantity desc) AS rank FROM cte)

SELECT segment_name, product_name, quantity FROM cte2
WHERE rank = 1;
-- Output (4 rows)
-- segment_name | product_name                 | quantity
-- Jacket       | Grey FAShiON Jacket - Womens | 3876
-- Jeans        | Navy Oversized Jeans - Womens| 3856
-- Shirt        | Blue Polo Shirt - Mens       | 3819
-- Socks        | Navy Solid Socks - Mens      | 3792

-- Query 13
-- What is the total quantity, revenue and disCOUNT for each category?
SELECT  s2.category_name, 
SUM(s1.qty) AS quantity, 
SUM(s1.price*s1.qty) AS revenue, 
round(SUM(s1.price*s1.qty*s1.disCOUNT/100.0),2) AS disCOUNT
FROM balanced_tree.sales s1 
JOIN balanced_tree.product_details s2 ON s1.prod_id=s2.product_id
GROUP by s2.category_name;
-- Output (2 rows)
-- category_name   | quantity   | revenue   | disCOUNT
-- Mens            | 22482      | 714120    | 86607.71
-- Womens          | 22734      | 575333    | 69621.43

-- Query 14
-- What is the top selling product for each category?
WITH cte AS (SELECT SUM(qty) AS quantity, 
s2.category_name, 
s2.product_name FROM balanced_tree.sales s1 
JOIN balanced_tree.product_details s2 ON s1.prod_id=s2.product_id
GROUP BY s2.category_name, s2.product_name
ORDER BY category_name, quantity desc), 
cte2 AS (SELECT *, 
rank() over( partitiON by category_name order by quantity desc) AS rank FROM cte)

SELECT category_name, product_name, quantity FROM cte2
WHERE rank = 1;
-- Output (2 rows)
-- category     | product_name                  | quantity
-- Mens         | Blue Polo Shirt - Mens        | 3819
-- Womens       | Grey FAShiON Jacket - Womens  | 3876

-- Query 15
-- What is the percentage split of revenue by product for each segment?
WITH cte AS (SELECT s2.segment_name, 
SUM(s1.price*s1.qty*(1-s1.disCOUNT/100.0)) AS revenue
FROM balanced_tree.sales s1 
JOIN balanced_tree.product_details s2 ON s1.prod_id=s2.product_id
GROUP BY s2.segment_name 
ORDER BY segment_name)

SELECT segment_name, 
round(revenue*100.0/(SELECT SUM(qty*price*(1-disCOUNT/100.0)) FROM balanced_tree.sales),2) AS percent_revenue 
FROM cte;
-- Output (4 rows)
-- segment_name     | percent_revenue
-- Jacket           | 28.48
-- Jeans            | 16.15
-- Shirt            | 31.46
-- Socks            | 23.91

-- Query 16
-- What is the percentage split of revenue by segment for each category?
WITH cte AS (SELECT s2.category_name, 
s2.segment_name, 
SUM(s1.price*s1.qty*(1-s1.disCOUNT/100.0)) AS revenue 
FROM balanced_tree.sales s1 
JOIN balanced_tree.product_details s2 ON s1.prod_id=s2.product_id
GROUP BY s2.category_name, s2.segment_name
ORDER BY category_name, segment_name), 
cte2 AS (SELECT *, 
SUM(revenue) over(partitiON by category_name) AS total_rev_cat FROM cte)

SELECT category_name, 
segment_name, 
revenue*100.0/total_rev_cat AS percent_rev FROM cte2;
-- Output (4 rows)
-- category_name | segment_name | percent_rev
-- Mens          | Shirt        | 56.819
-- Mens          | Socks        | 43.181
-- Womens        | Jacket       | 63.812
-- WOmens        | Jeans        | 36.189

-- Query 17
-- What is the percentage split of total revenue by category?
WITH cte AS (SELECT s2.category_name, 
SUM(s1.price*s1.qty*(1-s1.disCOUNT/100.0)*1.0) AS revenue 
FROM balanced_tree.sales s1 
JOIN balanced_tree.product_details s2 ON s1.prod_id = s2.product_id
GROUP BY s2.category_name)

SELECT category_name, 
revenue*100.0/(SELECT SUM(qty*price*(1-disCOUNT/100.0)) FROM balanced_tree.sales) AS percent_avn_cat 
FROM cte;
-- Output (2 rows)
-- category_name | percent_avn_cat
-- Mens          | 55.374
-- Womens        | 44.626

-- Query 18
-- What is the total transactiON “penetratiON” for each product? 
-- (hint: penetratiON = number of transactiONs where at leASt 1 quantity of a product wAS purchASed divided by total number of transactiONs)
SELECT prod_id,
COUNT(*)*100.0/(SELECT COUNT(*) FROM balanced_tree.sales) AS penetratiON 
FROM balanced_tree.sales
GROUP BY prod_id;
-- Output (12 rows)
-- prod_id | penetratiON
-- c4a632	8.4398807552169593
-- f084eb	8.4862537263994700
-- 9ec847	8.4465054653858894
-- e83aa3	8.2543888704869162
-- c8d436	8.2278900298111958
-- e31d39	8.2345147399801259
-- b9a74d	8.2345147399801259
-- 2a2353	8.4001324942033786
-- d5e9a6	8.2610135806558463
-- 72f5d4	8.2808877111626366
-- 2feb6b	8.3338853925140775
-- 5d267b	8.4001324942033786