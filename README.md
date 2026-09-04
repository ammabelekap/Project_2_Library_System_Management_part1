# Project_2_Library_System_Management_part1

## Project Overview

This project is a **Library Management System** developed using SQL to manage and analyze library-related data.

The project covers database creation, table relationships, data manipulation, data retrieval, aggregation, JOIN operations, and analytical queries. The database consists of information related to library branches, employees, books, members, book issues, and book returns.

The main objective of this project is to demonstrate practical SQL skills for **data management, relational database operations, and data analysis**.

## Database Structure

The database consists of six main tables:

| Table           | Description                                                                      |
| --------------- | -------------------------------------------------------------------------------- |
| `branch`        | Stores library branch information                                                |
| `employees`     | Stores employee and branch assignment information                                |
| `books`         | Stores book information, including category, author, publisher, and rental price |
| `member`        | Stores library member information                                                |
| `issue_status`  | Records books issued to members                                                  |
| `return_status` | Records returned books                                                           |

The database uses Primary Keys and Foreign Keys to establish relationships between tables. For example, `issue_status` is connected to `member`, `books`, and `employees`, while `return_status` is connected to `issue_status`.

---

## SQL Skills Demonstrated

This project demonstrates several SQL concepts, including:

* Database and table creation
* `CREATE TABLE`
* `ALTER TABLE`
* `INSERT`
* `UPDATE`
* `DELETE`
* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* Aggregate functions such as `SUM()` and `COUNT()`
* `INNER JOIN`
* `LEFT JOIN`
* Self JOIN
* Foreign Key relationships
* `CREATE TABLE AS SELECT (CTAS)`
* Date filtering using `CURRENT_DATE`
* `INTERVAL`
* Data filtering and analytical queries

--

##  Project Tasks & Analysis

### 1. Create a New Book Record

Added a new book titled **To Kill a Mockingbird** to the `books` table.

```sql
INSERT INTO books 
(isbn, book_title, category, rental_price, status, author, publisher) 
VALUES 
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

---

### 2. Update Member Information

Updated the address of a specific library member.

```sql
UPDATE member
SET member_address = '125 Main St'
WHERE member_id = 'C101';
```

---

### 3. Delete an Issued Book Record

Removed a specific record from the `issue_status` table.

```sql
DELETE FROM issue_status
WHERE issued_id = 'IS104';
```

---

### 4. Retrieve Books Issued by a Specific Employee

Used filtering to identify books issued by employee `E101`.

```sql
SELECT *
FROM issue_status
WHERE issued_emp_id = 'E101';
```

---

### 5. Identify Members Who Have Issued More Than One Book

Used `GROUP BY` and `HAVING` to identify employees associated with more than one issued book.

```sql
SELECT 
    issued_emp_id,
    COUNT(issued_id) AS total_book_issued
FROM issue_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;
```

---

### 6. Create a Book Issue Summary Table

Used **CTAS (Create Table As Select)** to create a summary table containing the number of times each book was issued.

```sql
CREATE TABLE book_cnts AS
SELECT 
    b.isbn,
    COUNT(ist.issued_id) AS no_issued,
    b.book_title
FROM books AS b
JOIN issue_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 3;
```

---

### 7. Retrieve Books from a Specific Category

Retrieved all books belonging to the `Classic` category.

```sql
SELECT *
FROM books
WHERE category = 'Classic';
```

---

### 8. Calculate Rental Information by Category

Used `SUM()` and `COUNT()` with JOIN operations to analyze rental information by book category.

```sql
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books AS b
JOIN issue_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY 1;
```

---

### 9. Identify Recently Registered Members

Retrieved members who registered within the last 180 days.

```sql
SELECT *
FROM member
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

---

### 10. Connect Employees with Branch Managers

Used multiple JOIN operations to connect employees, branches, and branch managers.

```sql
SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b
    ON b.branch_id = e1.branch_id
JOIN employees AS e2
    ON b.manager_id = e2.emp_id;
```

This demonstrates the use of a **self JOIN**, where the `employees` table is joined with itself to identify branch managers.

---

### 11. Create a Table for Books Above a Rental Price Threshold

Created a new table containing books with a rental price above **7 USD**.

```sql
CREATE TABLE books_price_greater_than_seven AS
SELECT *
FROM books
WHERE rental_price > 7;
```

---

### 12. Identify Books That Have Not Been Returned

Used a `LEFT JOIN` to identify issued books that do not have a corresponding return record.

```sql
SELECT DISTINCT ist.issued_book_name
FROM issue_status AS ist
LEFT JOIN return_status AS rs
    ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
```

This query helps identify **outstanding/unreturned books**.

---

## 📊 Key SQL Techniques

### JOIN Operations

The project applies different JOIN techniques to connect related information across tables, including:

* `INNER JOIN`
* `LEFT JOIN`
* Self JOIN

### Aggregation

Aggregate functions are used to generate insights from the database:

```sql
COUNT()
SUM()
```

These are combined with `GROUP BY` and `HAVING` to perform grouped analysis.

### Data Manipulation

The project also demonstrates practical database management through:

```sql
INSERT
UPDATE
DELETE
```

---

## 📁 Project Files

```text
Library-Management-System/
│
├── Project_2_Library_System_Management_part1.sql
└── README.md
```

The SQL file contains the database structure, relationships, sample data operations, and analytical queries.

---

##  Project Objectives

Through this project, I practiced:

* Designing relational database structures
* Creating and modifying SQL tables
* Establishing relationships using Primary Keys and Foreign Keys
* Manipulating data using CRUD operations
* Joining multiple tables
* Performing data aggregation
* Creating summary tables using CTAS
* Applying SQL for practical business/data analysis
* Identifying useful insights from relational data

---

##  Project Reference

YouTube tutorial/reference:

https://youtu.be/6X2-P9fNVvw?si=Zlg6cS1cyv87wkWI

---

Aspiring Data Analyst | SQL | Microsoft Excel

This project is part of my SQL learning portfolio, demonstrating my ability to work with relational databases and perform data analysis using SQL.
