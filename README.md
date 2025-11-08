# Data Warehouse and Analytics Project

## Executive Summary
This project demonstrates the complete lifecycle of a **Data Warehouse and Analytics Solution**, developed as part of a professional learning journey in **Data Engineering**.  
It showcases the design, integration, and analysis of data using modern industry standards, with emphasis on **SQL-based data modeling**, **ETL development**, and **business intelligence reporting**.

The project is **inspired by Data With Baraa’s tutorial**, re-created using **fully synthetic datasets** to ensure originality and compliance with data usage guidelines.

---

## Project Objectives
1. **Design a Scalable Data Warehouse**  
   Implement a modern **Medallion Architecture** (Bronze–Silver–Gold) to support analytical workloads.
2. **Build ETL Pipelines**  
   Develop reliable extraction, transformation, and loading workflows to process source data into structured models.
3. **Implement Data Modeling**  
   Design **star schemas** optimized for reporting and business intelligence.
4. **Deliver Actionable Insights**  
   Use **SQL and Power BI** to produce dashboards and reports that inform decision-making.

---

## Data Architecture

### Medallion Architecture Layers
| Layer | Purpose |
|--------|----------|
| **Bronze** | Raw data storage. Ingests CSV files directly into SQL Server for persistence and traceability. |
| **Silver** | Transformed and standardized data. Cleansed and validated for analytical use. |
| **Gold** | Curated business layer. Contains fact and dimension tables used for dashboards and reporting. |

This architecture ensures **data lineage, quality, and scalability**, aligning with modern data engineering principles.

---

## Technical Implementation

### Tools and Technologies
| Category | Tools Used |
|-----------|-------------|
| **Database** | SQL Server Express |
| **ETL Development** | SQL (T-SQL Scripts), SSMS |
| **Visualization** | Power BI |
| **Documentation & Modeling** | Draw.io, Notion |
| **Version Control** | Git & GitHub |

### Key Deliverables
- **Data Warehouse Design** with Bronze–Silver–Gold layer separation.  
- **ETL Scripts** for extraction, transformation, and loading.  
- **Data Models** including fact and dimension tables.  
- **Analytical Dashboards** built in Power BI.  
- **Comprehensive Documentation** including data dictionary and data flow diagrams.

---

## Project Workflow

1. **Data Ingestion (Bronze Layer)**  
   Import CSV files into SQL Server using SSMS or bulk insert commands.
2. **Data Transformation (Silver Layer)**  
   Clean and standardize the datasets, handle duplicates, missing values, and inconsistent keys.
3. **Data Modeling (Gold Layer)**  
   Create fact and dimension tables for:
   - Customer  
   - Product  
   - Location  
   - Sales  
4. **Analytics & Reporting**  
   Develop SQL queries and Power BI dashboards to analyze:
   - Sales trends  
   - Product performance  
   - Customer segmentation  

---

## Repository Structure
```
data-warehouse-project/
│
├── datasets/
│   ├── sources_crm
│   ├── sources_erp
│
├── docs/
│   ├── data_architecture.drawio
│   ├── data_flow.drawio
│   ├── data_models.drawio
│   ├── data_catalog.md
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│
├── reports/
│   ├── PowerBI_dashboard.pbix
│
├── README.md
└── LICENSE
```

---

## License
This project is distributed under the **MIT License**.  
You are free to use, adapt, and share this project with appropriate credit.

---

## About the Author
**M.N. Iman**  
📧 Email: [ieymnn17@gmail.com]
💼 Aspiring **Data Engineer** passionate about **data modeling**, **ETL pipelines**, and **analytics**.  
This project represents my journey in learning to design scalable, production-ready data systems.
