
/*
===============================================================================
DDL Script: Create Bronze Tables (CRM + ERP, Clean ISO Dates)
===============================================================================
Script Purpose:
    This script creates all Silver-layer tables for both CRM and ERP domains, 
    dropping existing ones if they already exist.
    IDs are stored as INT, prices as DECIMAL, and all dates as DATETIME
    since the source data uses consistent ISO (YYYY-MM-DD) formatting.
===============================================================================
*/

-----------------------------
-- CRM TABLES
-----------------------------

IF OBJECT_ID ('silver.crm_customers', 'U') IS NOT NULL
	DROP TABLE silver.crm_customers;
CREATE TABLE silver.crm_customers(
	customer_id			INT,
	customer_name		NVARCHAR(100),
	email				NVARCHAR(100),
	phone				NVARCHAR(50),
	city				NVARCHAR(50),
	registration_date	DATETIME,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_interactions', 'U') IS NOT NULL
	DROP TABLE silver.crm_interactions;
CREATE TABLE silver.crm_interactions(
	interaction_id		INT,
	customer_id			INT,
	interaction_type	NVARCHAR(50),
	channel				NVARCHAR(50),
	interaction_date	DATETIME,
	notes				NVARCHAR(MAX),
	agent_name			NVARCHAR(100),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
	
);

IF OBJECT_ID ('silver.crm_support_tickets', 'U') IS NOT NULL
	DROP TABLE silver.crm_support_tickets;
CREATE TABLE silver.crm_support_tickets(
	ticket_id			INT,
	customer_id			INT,
	subject				NVARCHAR(200),
	priority			NVARCHAR(50),
	status				NVARCHAR(50),
	created_date		DATETIME,
	resolved_date		DATETIME,
	assigned_to			NVARCHAR(100),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
	
);

-----------------------------
-- ERP TABLES
-----------------------------

IF OBJECT_ID ('silver.erp_products', 'U') IS NOT NULL
	DROP TABLE silver.erp_products;
CREATE TABLE silver.erp_products(
	product_id			INT,
	product_name		NVARCHAR(100),
	product_category	NVARCHAR(100),
	unit_price			DECIMAL(10,2),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_orders', 'U') IS NOT NULL
	DROP TABLE silver.erp_orders;
CREATE TABLE silver.erp_orders(
	order_id		INT,
	product_id		INT,
	customer_id		INT,
	quantity		INT,
	price			DECIMAL(10,2),
	order_date		DATETIME,
	shipping_date	DATETIME,
	payment_method	NVARCHAR(50),
	order_status	NVARCHAR(50),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_sales_transactions', 'U') IS NOT NULL
	DROP TABLE silver.erp_sales_transactions;
CREATE TABLE silver.erp_sales_transactions(
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
	sales_channel		NVARCHAR(50),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);
