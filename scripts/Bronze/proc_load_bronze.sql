
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    Loads data from CSV files into the Bronze schema for both CRM and ERP.
    Truncates existing tables and reloads fresh data using BULK INSERT.

File Paths:
    CRM CSVs: C:\Data\data-warehouse_project1\datasets\sources_crm\
    ERP CSVs: C:\Data\data-warehouse_project1\datasets\sources_erp\

Usage:
    EXEC bronze.load_bronze;
===============================================================================
*/
 
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'Starting Bronze Layer Load';
        PRINT '=============================================================';

        -----------------------------------------------------------------------
        -- CRM TABLES
        -----------------------------------------------------------------------
        PRINT '-------------------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-------------------------------------------------------------';

        -- bronze.crm_customers
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table: bronze.crm_customers';
        TRUNCATE TABLE bronze.crm_customers;

        PRINT '>>> Inserting Data Into: bronze.crm_customers';
        BULK INSERT bronze.crm_customers
        FROM 'C:\Data\data-warehouse_project1\datasets\sources_crm\customers.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration (crm_customers): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

        -- bronze.crm_interactions
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table: bronze.crm_interactions';
        TRUNCATE TABLE bronze.crm_interactions;

        PRINT '>>> Inserting Data Into: bronze.crm_interactions';
        BULK INSERT bronze.crm_interactions
        FROM 'C:\Data\data-warehouse_project1\datasets\sources_crm\interactions.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration (crm_interactions): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

        -- bronze.crm_support_tickets
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table: bronze.crm_support_tickets';
        TRUNCATE TABLE bronze.crm_support_tickets;

        PRINT '>>> Inserting Data Into: bronze.crm_support_tickets';
        BULK INSERT bronze.crm_support_tickets
        FROM 'C:\Data\data-warehouse_project1\datasets\sources_crm\support_tickets.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration (crm_support_tickets): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

        -----------------------------------------------------------------------
        -- ERP TABLES
        -----------------------------------------------------------------------
        PRINT '-------------------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-------------------------------------------------------------';

        -- bronze.erp_products
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table: bronze.erp_products';
        TRUNCATE TABLE bronze.erp_products;

        PRINT '>>> Inserting Data Into: bronze.erp_products';
        BULK INSERT bronze.erp_products
        FROM 'C:\Data\data-warehouse_project1\datasets\sources_erp\products.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration (erp_products): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

        -- bronze.erp_orders
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table: bronze.erp_orders';
        TRUNCATE TABLE bronze.erp_orders;

        PRINT '>>> Inserting Data Into: bronze.erp_orders';
        BULK INSERT bronze.erp_orders
        FROM 'C:\Data\data-warehouse_project1\datasets\sources_erp\orders.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration (erp_orders): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

        -- bronze.erp_sales_transactions
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table: bronze.erp_sales_transactions';
        TRUNCATE TABLE bronze.erp_sales_transactions;

        PRINT '>>> Inserting Data Into: bronze.erp_sales_transactions';
        BULK INSERT bronze.erp_sales_transactions
        FROM 'C:\Data\data-warehouse_project1\datasets\sources_erp\sales_transactions.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration (erp_sales_transactions): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

        -----------------------------------------------------------------------
        -- Summary
        -----------------------------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '=============================================================';
        PRINT 'Bronze Load Completed Successfully';
        PRINT 'Total Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '=============================================================';

    END TRY
    BEGIN CATCH
        PRINT '=============================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LOAD';
        PRINT 'Message: ' + ERROR_MESSAGE();
        PRINT 'Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=============================================================';
    END CATCH
END;
GO
