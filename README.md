# Restaurant Reservation Management System (RRMS)

## Overview
The **Restaurant Reservation Management System (RRMS)** is a SQL-based project designed to manage restaurants, customers, reservations, orders, menu items, and employees. The system supports complex querying, reporting, and analytics, enabling restaurants to efficiently track operations and make data-driven decisions.

## Features
- **Reservation Management:** Track and manage table reservations, party sizes, and reservation dates.
- **Order Tracking:** Manage customer orders and menu items, including total amounts and item quantities.
- **Employee Management:** Record employee roles and calculate salaries based on order performance.
- **Reporting:** Views, stored procedures, and functions provide analytics such as popular menu items, average order amounts, and restaurant revenue.
- **Audit Logging:** Triggers log reservation changes in an **AuditLog** table for accountability.
- **Performance Optimization:** Indexes improve query speed and query plans help monitor execution efficiency.

## Database Design
- **Entities:** Restaurants, MenuItems, Orders, OrderItems, Employees, Customers, RestaurantTables, Reservations.
- **Relationships:** 
  - One-to-many relationships (e.g., a restaurant has many tables, orders, and menu items).
  - Many-to-many relationships resolved via linking tables like `OrderItems`.
- **Keys:** Primary keys (PK) and foreign keys (FK) enforce data integrity.

## Implementation
- **Database Engine:** Microsoft SQL Server
- **Schema:** Includes all tables, constraints, and relationships.
- **Data Seeding:** Populated with realistic fictional data:
  - 50 Restaurants  
  - 1000 MenuItems  
  - 1500 OrderItems  
  - 500 Orders  
  - 100 Employees  
  - 500 Reservations  
  - 400 Customers  
  - 100 Tables
- **Queries and Functions:** Complex queries using joins, CTEs, and window functions for analytics.
- **Stored Procedures:** Automate tasks like adding orders and generating reports.
- **Triggers:** Automatically log reservations into `AuditLog`.

## Usage
1. Clone the repository.
2. Execute the schema creation scripts.
3. Seed the database using the provided DML scripts.
4. Run queries, functions, and stored procedures as needed.

## ERD
<img width="1422" height="1136" alt="ERD" src="https://github.com/user-attachments/assets/e47509d0-1197-44da-b8da-bff7db5c1000" />

## Notes
- Each SQL script is modular and can be executed independently.
- The system demonstrates relational database design, advanced SQL queries, procedural programming, and performance optimization.
