/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'IntegratedSalesDW' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'IntegratedSalesDW' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'IntegratedSalesDW' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'IntegratedSalesDW')
BEGIN
    ALTER DATABASE IntegratedSalesDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE IntegratedSalesDW;
END;
GO

-- Create the datawarehouse database as 'IntegratedSalesDW'
CREATE DATABASE IntegratedSalesDW;
GO

USE IntegratedSalesDW;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

