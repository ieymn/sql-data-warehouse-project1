/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
 
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		-- Loading silver.crm_customers
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_customers';
		TRUNCATE TABLE silver.crm_customers;
		PRINT '>> Inserting Data Into: silver.crm_customers';
		INSERT INTO silver.crm_customers (
			customer_id,
			customer_name,
			email,
			phone,
			city,
			registration_date
		)
		SELECT 
			customer_id,
			LTRIM(RTRIM(customer_name)),					 -- Romove any unwanted spaces
			COALESCE(LTRIM(RTRIM(email)), 'n/a') AS email,   
			COALESCE(LTRIM(RTRIM(phone)), 'n/a') AS phone,   -- Replace NULL  with 'n/a' and remove any unwanted spaces
			city,
			CAST(registration_date AS DATE) AS registration_date
		FROM(
		SELECT
			*,
			ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY registration_date DESC ) AS flag_last
		FROM bronze.crm_customers
		WHERE customer_id IS NOT NULL
		)t WHERE flag_last = 1;  -- Select only the latest record for each customer if have duplicate ID
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		  -- Loading crm_interacions
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_interactions';
		TRUNCATE TABLE silver.crm_interactions;
		PRINT '>> Inserting Data Into: silver.crm_intractions';
		INSERT INTO silver.crm_interactions (
			interaction_id,
			customer_id,
			interaction_type,
			channel,
			interaction_date,
			notes,
			agent_name
		)
		SELECT
			interaction_id,
			customer_id,
			UPPER(LEFT(LTRIM(RTRIM(interaction_type)), 1)) +
			SUBSTRING(LTRIM(RTRIM(interaction_type)), 2, LEN(LTRIM(RTRIM(interaction_type)))) interaction_type,
			
			UPPER(LEFT(LTRIM(RTRIM(channel)),1)) + 
			SUBSTRING(LTRIM(RTRIM(channel)), 2, LEN(LTRIM(RTRIM(channel)))) AS channel,       -- Clean and normalize subject text (trim spaces, capitalize first letter)
			
			CAST(interaction_date AS DATE) AS interaction_date,
			COALESCE(LTRIM(RTRIM(notes)), 'n/a') AS notes,          -- Replace NULL  with 'n/a' and remove any unwanted spaces 
			LTRIM(RTRIM(agent_name)) AS agent_name
		FROM bronze.crm_interactions
		WHERE customer_id IS NOT NULL  -- Exclude bad records
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		  -- Loading crm_support_tickets
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_support_tickets';
		TRUNCATE TABLE silver.crm_support_tickets;
		PRINT '>> Inserting Data Into: silver.crm_support_tickets';
		INSERT INTO silver.crm_support_tickets (
			ticket_id,
			customer_id,
			subject,
			priority,
			status,
			created_date,
			resolved_date,
			assigned_to
		)
		SELECT 
			ticket_id,               
			customer_id,
			UPPER(LEFT(LTRIM(RTRIM(subject)), 1)) + 
			SUBSTRING(LTRIM(RTRIM(subject)), 2, LEN(LTRIM(RTRIM(subject)))) AS subject,   -- Clean and normalize subject text (trim spaces, capitalize first letter)
			CASE 
				WHEN priority IS NULL THEN 'Unknown' 
				ELSE UPPER(LEFT(LTRIM(RTRIM(priority)), 1)) + 
					 SUBSTRING(LTRIM(RTRIM(priority)), 2, LEN(LTRIM(RTRIM(priority))))  
			END AS priority,                                                            -- Standardize status text and fill missing with 'Unknown'
			CASE 
				WHEN status IS NULL THEN 'Unknown'
				ELSE UPPER(LEFT(LTRIM(RTRIM(status)), 1)) + SUBSTRING(LTRIM(RTRIM(status)), 2, LEN(LTRIM(RTRIM(status))))
			END AS status,
			CAST(created_date AS DATE) AS created_date,
			CAST(resolved_date AS DATE) AS resolved_date,
			COALESCE(LTRIM(RTRIM(assigned_to)), 'Unassigned') AS assigned_to
		FROM bronze.crm_support_tickets
		WHERE customer_id IS NOT NULL;  -- Exclude invalid ticket
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		
		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

		
		  -- Loading erp_orders
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_orders';
		TRUNCATE TABLE silver.erp_orders;
		PRINT '>> Inserting Data Into: silver.erp_orders';
		INSERT INTO silver.erp_orders(
			order_id,
			product_id,
			customer_id,
			quantity,
			price,
			order_date,
			shipping_date,
			payment_method,
			order_status
		)
		SELECT  
			order_id,
			product_id,
			customer_id,
			quantity,
			price,
			CAST(order_date AS DATE) AS order_date,
			CAST(shipping_date AS DATE) AS shipping_date,	-- Remove time portion, keep only date
			payment_method,
			CONCAT(
				UPPER(LEFT(LTRIM(RTRIM(order_status)), 1)), 
				LOWER(SUBSTRING(LTRIM(RTRIM(order_status)), 2, LEN(LTRIM(RTRIM(order_status))) - 1))  --Correctly format order_status text
			) AS order_status
		FROM bronze.erp_orders
		WHERE order_id IS NOT NULL;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		 -- Loading erp_products
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_products';
		TRUNCATE TABLE silver.erp_products;
		PRINT '>> Inserting Data Into: silver.erp_products';
		INSERT INTO silver.erp_products (
			product_id,
			product_name,
			product_category,
			unit_price
		)
		SELECT
			product_id,
			(
				SELECT STRING_AGG(CONCAT(UPPER(LEFT(value, 1)), LOWER(SUBSTRING(value, 2, LEN(value)))), ' ')	-- Proper case transformation
				FROM STRING_SPLIT(LTRIM(RTRIM(product_name)), ' ')
			) AS product_name,	 
			CONCAT(
				UPPER(LEFT(LTRIM(RTRIM(product_category)), 1)),
				LOWER(SUBSTRING(LTRIM(RTRIM(product_category)), 2, LEN(LTRIM(RTRIM(product_category))) - 1))    -- Standardize category text
			) AS product_category,
			COALESCE(unit_price, 0) AS unit_price    -- Handle missing prices (if any)
		FROM bronze.erp_products
		WHERE product_id IS NOT NULL;
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		
		  -- Loading erp_sales_transactions
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_sales_transactions';
		TRUNCATE TABLE silver.erp_sales_transactions;
		PRINT '>> Inserting Data Into: silver.erp_sales_transactions';
		INSERT INTO silver.erp_sales_transactions (
			transaction_id,
			order_id,
			customer_id,
			product_id,
			transaction_date,
			quantity,
			unit_price,
			discount,
			total_amount,
			payment_type,
			sales_channel  
		)
		SELECT
			transaction_id,
			order_id,
			customer_id,
			product_id,
			CAST(transaction_date AS DATE) AS transaction_date,  -- remove time
			quantity,
			COALESCE(unit_price, 0) AS unit_price,
			COALESCE(discount, 0) AS discount,
			COALESCE(total_amount, unit_price * quantity * (1 - discount)) AS total_amount,
			CONCAT(
				UPPER(LEFT(LTRIM(RTRIM(payment_type)), 1)),
				LOWER(SUBSTRING(LTRIM(RTRIM(payment_type)), 2, LEN(LTRIM(RTRIM(payment_type))) - 1))    -- Clean and standardize text columns
			) AS payment_type,
			CONCAT(
				UPPER(LEFT(LTRIM(RTRIM(sales_channel)), 1)),
				LOWER(SUBSTRING(LTRIM(RTRIM(sales_channel)), 2, LEN(LTRIM(RTRIM(sales_channel))) - 1))
			) AS sales_channel
		FROM bronze.erp_sales_transactions
		WHERE transaction_id IS NOT NULL;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
