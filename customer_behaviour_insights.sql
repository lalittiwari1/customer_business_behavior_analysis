-- =====================================================================
-- Customer Shopping Behavior Analysis — SQL
-- Source: UCI "Online Retail" dataset (UK-based online gift retailer,
-- Dec 2010 - Dec 2011), cleaned and RFM-segmented in the notebook.
--
-- Tables (both exported by the notebook):
--   online_retail  -> cleaned line-item transactions, one row per
--                      product per invoice, with rfm_segment attached
--   customer_rfm   -> one row per customer with recency/frequency/
--                      monetary values, scores, and rfm_segment
--
-- Business question:
-- Which customers generate the most revenue and show the strongest
-- loyalty signals, and what does their behavior tell us about how to
-- retain and grow the highest-value segments?
-- =====================================================================


-- 1. How many customers fall into each RFM segment, and what share
--    of total revenue does each segment contribute?
SELECT
    rfm_segment,
    COUNT(*)                                        AS num_customers,
    ROUND(AVG(monetary), 2)                         AS avg_customer_spend,
    ROUND(SUM(monetary), 2)                         AS total_revenue,
    ROUND(100.0 * SUM(monetary)
          / SUM(SUM(monetary)) OVER (), 2)          AS pct_of_total_revenue
FROM customer_rfm
GROUP BY rfm_segment
ORDER BY total_revenue DESC;


-- 2. Average recency, frequency, and order behavior by segment
--    (how "at risk" is each segment, concretely, in days/orders?).
SELECT
    rfm_segment,
    ROUND(AVG(recency), 1)   AS avg_days_since_last_order,
    ROUND(AVG(frequency), 1) AS avg_num_orders,
    ROUND(AVG(monetary), 2)  AS avg_total_spend
FROM customer_rfm
GROUP BY rfm_segment
ORDER BY avg_days_since_last_order;


-- 3. Top 5 products by revenue within each RFM segment
--    (what to feature/restock for the highest-value customers).
WITH product_revenue AS (
    SELECT
        r.rfm_segment,
        t.description,
        SUM(t.total_price)                                                    AS revenue,
        ROW_NUMBER() OVER (PARTITION BY r.rfm_segment ORDER BY SUM(t.total_price) DESC) AS product_rank
    FROM online_retail t
    JOIN customer_rfm r ON t.customer_id = r.customer_id
    GROUP BY r.rfm_segment, t.description
)
SELECT rfm_segment, product_rank, description, revenue
FROM product_revenue
WHERE product_rank <= 5
ORDER BY rfm_segment, product_rank;


-- 4. Revenue and customer count by country, joined with segment mix
--    (are non-UK markets under- or over-represented in Champions?).
SELECT
    t.country,
    r.rfm_segment,
    COUNT(DISTINCT t.customer_id)   AS num_customers,
    ROUND(SUM(t.total_price), 2)    AS revenue
FROM online_retail t
JOIN customer_rfm r ON t.customer_id = r.customer_id
GROUP BY t.country, r.rfm_segment
ORDER BY revenue DESC
LIMIT 20;


-- 5. Monthly revenue trend, split by whether the customer is a
--    Champion/Loyal customer or not — are top customers driving
--    growth, or is growth coming from new/occasional buyers?
SELECT
    DATE_TRUNC('month', t.invoice_date)                         AS month,
    CASE WHEN r.rfm_segment IN ('Champions','Loyal')
         THEN 'Champions/Loyal' ELSE 'Other' END                AS customer_group,
    ROUND(SUM(t.total_price), 2)                                AS revenue
FROM online_retail t
JOIN customer_rfm r ON t.customer_id = r.customer_id
GROUP BY 1, 2
ORDER BY 1, 2;


-- 6. Customers with a very high monetary value but poor recency/
--    frequency scores — large one-off buyers worth a personal
--    win-back outreach rather than a generic campaign.
SELECT customer_id, recency, frequency, monetary, rfm_segment
FROM customer_rfm
WHERE monetary > (SELECT AVG(monetary) FROM customer_rfm) * 3
  AND recency > (SELECT AVG(recency) FROM customer_rfm)
ORDER BY monetary DESC;


-- 7. Average order value (per invoice) by RFM segment.
SELECT
    r.rfm_segment,
    ROUND(AVG(invoice_total), 2) AS avg_order_value
FROM (
    SELECT invoice_no, customer_id, SUM(total_price) AS invoice_total
    FROM online_retail
    GROUP BY invoice_no, customer_id
) AS invoices
JOIN customer_rfm r ON invoices.customer_id = r.customer_id
GROUP BY r.rfm_segment
ORDER BY avg_order_value DESC;


-- 8. Top 10 products overall by quantity sold and by revenue
--    (candidates for homepage/marketing placement).
SELECT
    description,
    SUM(quantity)               AS total_units_sold,
    ROUND(SUM(total_price), 2)  AS total_revenue
FROM online_retail
GROUP BY description
ORDER BY total_revenue DESC
LIMIT 10;


-- 9. Customer count and revenue contribution for the "Needs
--    Attention" and "At Risk" segments specifically — the target
--    list for a win-back campaign.
SELECT
    rfm_segment,
    customer_id,
    recency,
    frequency,
    monetary
FROM customer_rfm
WHERE rfm_segment IN ('At Risk', 'Needs Attention')
ORDER BY monetary DESC;
