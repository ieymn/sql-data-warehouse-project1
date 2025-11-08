
/*
===============================================================================
DDL Script: Create Bronze Tables (CRM + ERP, Clean ISO Dates)
===============================================================================
Script Purpose:
    This script creates all Bronze-layer tables for both CRM and ERP domains, 
    dropping existing ones if they already exist.
    IDs are stored as INT, prices as DECIMAL, and all dates as DATETIME
    since the source data uses consistent ISO (YYYY-MM-DD) formatting.
===============================================================================
*/

-----------------------------
-- CRM TABLES
-----------------------------

IF OBJECT_ID ('bronze.crm_customers', 'U') IS NOT NULL
	DROP TABLE bronze.crm_customers;
CREATE TABLE bronze.crm_customers(
	customer_id			INT,
	customer_name		NVARCHAR(100),
	email				NVARCHAR(100),
	phone				NVARCHAR(50),
	city				NVARCHAR(50),
	registration_date	DATETIME
);

IF OBJECT_ID ('bronze.crm_interactions', 'U') IS NOT NULL
	DROP TABLE bronze.crm_interactions;
CREATE TABLE bronze.crm_interactions(
	interaction_id		INT,
	customer_id			INT,
	interaction_type	NVARCHAR(50),
	channel				NVARCHAR(50),
	interaction_date	DATETIME,
	notes				NVARCHAR(MAX),
	agent_name			NVARCHAR(100)
	
);

IF OBJECT_ID ('bronze.crm_support_tickets', 'U') IS NOT NULL
	DROP TABLE bronze.crm_support_tickets;
CREATE TABLE bronze.crm_support_tickets(
	ticket_id			INT,
	customer_id			INT,
	subject				NVARCHAR(200),
	priority			NVARCHAR(50),
	status				NVARCHAR(50),
	created_date		DATETIME,
	resolved_date		DATETIME,
	assigned_to			NVARCHAR(100)
	
);

-----------------------------
-- ERP TABLES
-----------------------------

IF OBJECT_ID ('bronze.erp_products', 'U') IS NOT NULL
	DROP TABLE bronze.erp_products;
CREATE TABLE bronze.erp_products(
	product_id			INT,
	product_name		NVARCHAR(100),
	product_category	NVARCHAR(100),
	unit_price			DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.erp_orders', 'U') IS NOT NULL
	DROP TABLE bronze.erp_orders;
CREATE TABLE bronze.erp_orders(
	order_id		INT,
	product_id		INT,
	customer_id		INT,
	quantity		INT,
	price			DECIMAL(10,2),
	order_date		DATETIME,
	shipping_date	DATETIME,
	payment_method	NVARCHAR(50),
	order_status	NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_sales_transactions', 'U') IS NOT NULL
	DROP TABLE bronze.erp_sales_transactions;
CREATE TABLE bronze.erp_sales_transactions(
	transaction_id		INT,
	order_id			INT,
	customer_id			INT,
	product_id			INT,
	transaction_date	DATETIME,
	quantity			INT,
	unit_price			DECIMAL(10,2),
	discount			DECIMAL(10,2),
	total_amount		DECIMAL(10,2),
	payment_type		NVARCHAR(50),
	sales_channel		NVARCHAR(50)
);
