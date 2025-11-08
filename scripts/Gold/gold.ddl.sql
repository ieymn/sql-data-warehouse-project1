/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY c.customer_id) AS customer_key,
    c.customer_id,
    c.customer_name,
    c.email,
    c.phone,
    c.city,
    COUNT(DISTINCT i.interaction_id) AS total_interactions,
    MAX(i.interaction_date) AS last_interaction_date,
    COUNT(DISTINCT s.ticket_id) AS total_support_tickets,
    MAX(s.created_date) AS last_ticket_date,
    CASE                                                                       -- Engagement (based on interactions)
        WHEN COUNT(DISTINCT i.interaction_id) = 0 THEN 'Low'
        WHEN COUNT(DISTINCT i.interaction_id) BETWEEN 1 AND 3 THEN 'Moderate'
        ELSE 'High'
    END AS engagement_level,
    CASE                                                                       -- Support load (based on tickets)     
        WHEN COUNT(DISTINCT s.ticket_id) = 0 THEN 'No Support'            
        WHEN COUNT(DISTINCT s.ticket_id) BETWEEN 1 AND 2 THEN 'Some Support'
        ELSE 'Frequent Support'
    END AS support_category

FROM silver.crm_customers AS c
LEFT JOIN silver.crm_interactions AS i
ON c.customer_id = i.customer_id
LEFT JOIN silver.crm_support_tickets AS s
ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.phone, c.city;

GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key,
    p.product_id,
    p.product_name,
    p.product_category,
    p.unit_price,
    CASE 
        WHEN p.unit_price IS NULL THEN 'Missing Price'
        WHEN p.product_name IS NULL THEN 'Missing Name'
        ELSE 'Valid'
    END AS data_quality_status
FROM silver.erp_products AS p;

GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    st.transaction_id,
    st.order_id,
    c.customer_key,
    p.product_key,
    c.customer_name,
    st.transaction_date,
    st.quantity,
    st.unit_price,
    st.discount,
    st.total_amount,
    COALESCE(o.payment_method, 'Unknown') AS payment_method,
    COALESCE(o.order_date, st.transaction_date) AS order_date,
    o.shipping_date,
    o.order_status
FROM silver.erp_sales_transactions AS st
LEFT JOIN silver.erp_orders AS o
    ON st.order_id = o.order_id 
LEFT JOIN gold.dim_products AS p
    ON st.product_id = p.product_key
LEFT JOIN gold.dim_customers AS c
    ON st.customer_id = c.customer_key;

GO
