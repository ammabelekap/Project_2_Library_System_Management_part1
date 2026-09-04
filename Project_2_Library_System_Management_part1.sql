--Library Management SQL Project 
--Create Database
--Create table 'Branch'
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
	(
		branch_id VARCHAR (10) PRIMARY KEY,
		manager_id VARCHAR (10),
		branch_address VARCHAR (30),
		contact_no VARCHAR (15)
);
ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR (25)
--Create table 'Employee'
DROP TABLE IF EXISTS employees
CREATE TABLE employees
	(
		emp_id VARCHAR (10) PRIMARY KEY,
		emp_name VARCHAR (25),
		position VARCHAR (15),
		salary INT,
		branch_id VARCHAR (25) --FK
);
ALTER TABLE employees
ALTER COLUMN salary TYPE DECIMAL (10,2)
--Create table 'Books'
CREATE TABLE books
	(
		isbn VARCHAR (20) PRIMARY KEY,
		book_title VARCHAR (75),
		category VARCHAR (15),
		rental_price FLOAT,
		status VARCHAR (10),
		author VARCHAR (35),
		publisher VARCHAR (55)
	);
ALTER TABLE books 
ALTER COLUMN category TYPE VARCHAR (25)
--Create table 'Member'
CREATE TABLE member
	(
		member_id VARCHAR (10) PRIMARY KEY,
		member_name VARCHAR (25),
		member_address VARCHAR (75),
		reg_date DATE
	);
--Create Table 'Issue Status'
CREATE TABLE issue_status
	(
	issued_id VARCHAR (10) PRIMARY KEY,
	issued_member_id VARCHAR (10),--FK
	issued_book_name VARCHAR (75),
	issued_date DATE,
	issued_book_isbn VARCHAR (25),--FK
	issued_emp_id VARCHAR (15) --FK
	);
--Create Table 'Return Status'
CREATE TABLE return_status
	(
	return_id VARCHAR (10) PRIMARY KEY,
	issued_id VARCHAR (10),--FK
	return_book_name VARCHAR (75),
	return_date DATE,
	return_book_isbn VARCHAR (20)--FK
	);
-- inserting into return table
INSERT INTO return_status(return_id, issued_id, return_date) 
VALUES
('RS104', 'IS106', '2024-05-01'),
('RS105', 'IS107', '2024-05-03'),
('RS106', 'IS108', '2024-05-05'),
('RS107', 'IS109', '2024-05-07'),
('RS108', 'IS110', '2024-05-09'),
('RS109', 'IS111', '2024-05-11'),
('RS110', 'IS112', '2024-05-13'),
('RS111', 'IS113', '2024-05-15'),
('RS112', 'IS114', '2024-05-17'),
('RS113', 'IS115', '2024-05-19'),
('RS114', 'IS116', '2024-05-21'),
('RS115', 'IS117', '2024-05-23'),
('RS116', 'IS118', '2024-05-25'),
('RS117', 'IS119', '2024-05-27'),
('RS118', 'IS120', '2024-05-29');
SELECT * FROM issue_status
--FOREIGN KEY
ALTER TABLE issue_status
ADD CONSTRAINT fk_member
FOREIGN KEY (issued_member_id)
REFERENCES member(member_id)

ALTER TABLE issue_status
ADD CONSTRAINT fk_book
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn)

ALTER TABLE issue_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees (emp_id)

ALTER TABLE employees
ADD CONSTRAINT fk_barch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id)

ALTER TABLE return_status
ADD CONSTRAINT fk_issue_status
FOREIGN KEY (issued_id)
REFERENCES issue_status(issued_id);

--To make sure the data 
SELECT * FROM books
SELECT * FROM branch
SELECT * FROM employees
SELECT * FROM issue_status
SELECT * FROM member
SELECT * FROM return_status

--Project Task
- Task 1. Create a New Book Record --"978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher) 
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address
UPDATE member
SET member_address ='125 Main St'
WHERE member_id='C101'

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.
DELETE FROM issue_status
WHERE issued_id='IS104'

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issue_status
WHERE issued_emp_id='E101'

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT 
		issued_emp_id,
		COUNT(issued_id) as total_book_issued
FROM issue_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1

-- ### 3. CTAS (Create Table As Select)
-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
--Join between table books and statue_issue
SELECT *
FROM books as b
JOIN issue_status as ist
ON ist.issued_book_isbn = b.isbn

CREATE TABLE book_cnts
AS
SELECT 
		b.isbn,
		COUNT(ist.issued_id) as no_issued,
		b.book_title
FROM books as b
JOIN issue_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,3;
SELECT * FROM book_cnts

-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:
SELECT* FROM books
WHERE category='Classic'

-- Task 8: Find Total Rental Income by Category:
SELECT 
	b.category,
	SUM(b.rental_price),
	COUNT(*)
FROM books as b
JOIN issue_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

-- Task 9. **List Members Who Registered in the Last 180 Days**:
SELECT * FROM member
WHERE reg_date>= CURRENT_DATE - INTERVAL '180 days'

INSERT INTO member (member_id, member_name, member_address, reg_date) 
VALUES 
	('C121', 'Sandy Kristian', '501 Reinfold St', '2026-02-20'),
	('C122', 'Axel Giovani', '305 Kharisma St', '2026-03-5'),
	('C123', 'Maxwell Salvador', '277 Robert St', '2026-04-20');

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:
SELECT* FROM branch
SELECT* FROM employees

SELECT* 
FROM employees as e1
JOIN 
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON
b.manager_id = e2.emp_id
--create new
CREATE TABLE brch_manager
AS
SELECT 
	e1.*,
	b.manager_id,
	e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON
b.manager_id = e2.emp_id
SELECT 
	branch_id,
	manager_id,
	manager
	FROM brch_manager

-- Task 11. Create a Table 
-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7 USD
CREATE TABLE books_price_greater_than_seven
AS
SELECT * FROM books
WHERE rental_price > 7
SELECT * FROM books_price_greater_than_seven

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issue_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id

SELECT 
	DISTINCT ist.issued_book_name
FROM issue_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL