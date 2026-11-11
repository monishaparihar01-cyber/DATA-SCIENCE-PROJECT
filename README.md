# DATA-SCIENCE-PROJECT
# 📚 Library Management System

**Project Type:** DBMS Mini Project  
**Course:** Bachelor of Computer Applications (BCA)  
**Database:** MySQL  
**Database Name:** `librarydb`  
**Software:** MySQL Workbench  

---

## 📌 1. Introduction

The **Library Management System** is a mini project developed using **MySQL**.

The project is designed to maintain information about:

- Library members
- Books available in the library
- Books borrowed by members
- Book return dates
- Late returns and fines

The main purpose of this project is to understand how a relational database works and how SQL queries can be used to retrieve, analyse and manage data.

---

## 🗃️ 2. Database Structure

The database contains **3 tables**:

### Members

Stores information about students and faculty members.

| Column | Description |
|---|---|
| `member_id` | Primary Key |
| `member_name` | Name of member |
| `member_type` | Student or Faculty |
| `joined_date` | Date of joining |

### Books

Stores information about books available in the library.

| Column | Description |
|---|---|
| `book_id` | Primary Key |
| `title` | Book title |
| `author` | Author name |
| `category` | Book category |
| `price` | Price of book |
| `copies_available` | Number of available copies |

### Issues

Stores information about books borrowed by members.

| Column | Description |
|---|---|
| `issue_id` | Primary Key |
| `member_id` | Foreign Key |
| `book_id` | Foreign Key |
| `issue_date` | Date the book was issued |
| `due_date` | Expected return date |
| `return_date` | Actual return date |

A `NULL` value in `return_date` means that the book has **not yet been returned**.

---

## 🔗 3. Database Relationships

There are two **one-to-many (1:N)** relationships.

```text
MEMBERS (1) ───────────< ISSUES (N)

BOOKS   (1) ───────────< ISSUES (N)
```

### Members → Issues

One member can have many issue records.

### Books → Issues

One book can have many issue records over time.

The `issues` table connects the `members` and `books` tables using foreign keys.

---

## 🖼️ 4. ER Diagram

![Library Management System ER Diagram](erd.jpg)

---

## 📊 5. Sample Database

The project uses the following sample data:

| Table | Records |
|---|---:|
| Members | 8 |
| Books | 10 |
| Issues | 16 |

### Members

The database contains both:

- Students
- Faculty members

### Book Categories

The books belong to categories such as:

- Database
- Programming
- Fiction
- Technology

---

## 💰 6. Fine Calculation

The library charges **₹2 for every day a book is returned late**.

### Formula

```text
Fine = Late Days × ₹2
```

Late days are calculated using the MySQL `DATEDIFF()` function.

Example:

```text
Due Date:       16 September
Return Date:    20 September

Late Days = 4

Fine = 4 × ₹2
     = ₹8
```

### Rules

- Books returned after the due date are considered late.
- Books returned on the due date have no fine.
- Books with `NULL` as the return date are currently issued.
- Late books are charged ₹2 per late day.

---

## 💻 7. SQL Concepts Used

This project demonstrates the following SQL concepts:

1. Database and table creation
2. Primary Keys
3. Foreign Keys
4. `SELECT`
5. `WHERE`
6. `COUNT()`
7. `SUM()`
8. `GROUP BY`
9. `HAVING`
10. `ORDER BY`
11. `LIMIT`
12. `INNER JOIN`
13. `LEFT JOIN`
14. Subqueries
15. `NULL` handling
16. `DATEDIFF()`
17. Window functions using `RANK()`
18. Stored Procedures
19. Triggers

---

# 📝 8. Project Questions

## Phase 1 – Database Basics

### C1 – ER Diagram

Created an ER diagram showing the three tables, primary keys, foreign keys and relationships.

### C2 – Count Records

Find the total number of members, books and issue records.

Expected result:

```text
Members: 8
Books: 10
Issues: 16
```

---

## Phase 2 – Business Questions

### C3 – Books by Category

Find the number of titles and total available copies in each category.

### C4 – Top 5 Most Borrowed Books

Find the five books that have been borrowed the most.

**Result:** `SQL Basics` is the most borrowed book in the sample data.

### C5 – Members Who Never Borrowed

Find members who have never borrowed a book.

**Result:** `Rohan`

### C6 – Currently Issued Books

Find books that have not yet been returned.

This is identified using:

```sql
WHERE return_date IS NULL
```

### C7 – Late Returns

Find books returned after their due date and calculate the number of late days and fine.

### C8 – Total Fine Per Member

Calculate the total fine for every member who has returned books late.

### C9 – Student vs Faculty Usage

Compare the number of books borrowed by Students and Faculty.

Sample result:

| Member Type | Books Borrowed |
|---|---:|
| Student | 11 |
| Faculty | 5 |

### C10 – Member Ranking

Rank members according to the number of books they have borrowed using `RANK()`.

### C11 – Most Popular Category

Find the category with the highest number of issues.

**Result:** `Database`

### C12 – Zero Copies with Pending Issues

Find books that have zero available copies and also have a pending issue.

**Result:** `SQL Basics`

---

# ⚙️ 9. Database Automation

## C13 – Stored Procedure

A stored procedure named `member_history` is created to display all books borrowed by a particular member.

Example:

```sql
CALL member_history(1);
```

This displays the borrowing history of member `1`.

---

## C14 – Trigger

A trigger is created to automatically decrease the number of available copies whenever a new book issue is inserted.

Example:

```text
Before issuing:
copies_available = 3

After issuing:
copies_available = 2
```

This helps keep the available-copy information updated automatically.

---

# 📈 10. Important Results

Based on the sample data:

### Most Borrowed Book

```text
SQL Basics → 7 borrowings
```

### Member Who Never Borrowed

```text
Rohan
```

### Most Popular Category

```text
Database → 9 issues
```

### Student vs Faculty

```text
Students → 11 books
Faculty  → 5 books
```

### Books Currently Issued

Books with `return_date = NULL` are currently issued and have not been returned.

### Total Fines

| Member | Fine |
|---|---:|
| Rahul | ₹24 |
| Priya | ₹12 |
| Arjun | ₹8 |
| Kiran | ₹4 |
| Meena | ₹8 |

---

# 📂 11. Project Files

```text
Library-Management-SQL/
│
├── README.md
├── library_project.sql
└── erd.jpg
```

### File Description

| File | Description |
|---|---|
| `README.md` | Project documentation |
| `library_project.sql` | Database, sample data and SQL queries |
| `erd.jpg` | Entity Relationship Diagram |

---

# ▶️ 12. How to Run

1. Open **MySQL Workbench**.
2. Open `library_project.sql`.
3. Execute the SQL file.
4. Select the `librarydb` database.
5. Run the queries for C2–C14.
6. Check the results.

To verify the number of records:

```sql
USE librarydb;

SELECT COUNT(*) FROM members;
SELECT COUNT(*) FROM books;
SELECT COUNT(*) FROM issues;
```

Expected result:

```text
Members: 8
Books: 10
Issues: 16
```

---

# 🎓 13. Learning Outcomes

Through this project, I learned how to:

- Create relational databases using MySQL.
- Create tables using primary and foreign keys.
- Insert and retrieve data.
- Use aggregate functions such as `COUNT()` and `SUM()`.
- Use `GROUP BY`, `ORDER BY` and `LIMIT`.
- Use `INNER JOIN` and `LEFT JOIN`.
- Handle `NULL` values.
- Use subqueries.
- Calculate dates using `DATEDIFF()`.
- Rank records using `RANK()`.
- Create stored procedures.
- Create triggers for database automation.

---

# 💡 14. Conclusion

The Library Management System demonstrates how MySQL can be used to manage and analyse library records.

The SQL queries help identify popular books, popular categories, members who have never borrowed books, currently issued books and late-return fines.

From the sample data, **SQL Basics** is the most borrowed book and **Database** is the most popular category.

The library can consider purchasing additional copies of highly borrowed books, especially books with zero available copies and pending issues.

Members with overdue books can also be given reminders to reduce late returns and fines.

Overall, this project improved my practical understanding of **MySQL, SQL queries, database relationships, joins, subqueries, stored procedures and triggers**.

---

## 👩‍💻 Project

**Library Management System – MySQL DBMS Mini Project**

**Database:** `librarydb`  
**Tables:** `members`, `books`, `issues`  
**Database Tool:** MySQL Workbench
