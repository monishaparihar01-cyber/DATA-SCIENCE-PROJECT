create database librarydb;
use librarydb;
create table members(
    member_id   int primary key AUTO_INCREMENT,
    member_name VARCHAR(100) NOT NULL,
    member_type VARCHAR(10)  NOT NULL,
    joined_date DATE         NOT NULL
);
create table books (
    book_id int primary key auto_increment,
    title varchar(150) not null,
    author varchar(100),
    category varchar(100),
    price decimal(10,2),
    copies_available int default 0
);
create table issues(
	issue_id int primary key auto_increment,
    member_id int not null,
    book_id int not null,
    issue_date date not null,
    due_date date not null,
    return_date date null,
    foreign key(member_id) references members(member_id),
    foreign key(book_id) references books(book_id)
);
#check if every table got created.
desc members;
desc books;
desc issues;

#inserting values into tables
insert into members(member_id,member_name,member_type,joined_date)values
	(1,'Rahul','Student','2026-01-10'),
	(2,'Priya','Student','2026-01-12'),
	(3,'Arjun','Student','2026-01-15'),
	(4,'Sneha','Faculty','2026-01-20'),
	(5,'Kiran','Student','2026-02-01'),
	(6,'Meena','Faculty','2026-02-05'),
	(7,'Rohan','Student','2026-02-10'),
	(8,'Anjali','Faculty','2026-02-15');
    
insert into books(book_id,title,author,category,price,copies_available)values
	(101,'SQL Basics','John Smith','Database',500,0),
	(102,'MySQL Guide','David Lee','Database',600,2),
	(103,'Python Basics','Mark Lee','Programming',550,3),
	(104,'Java Fundamentals','James Brown','Programming',650,4),
	(105,'Harry Potter','J.K. Rowling','Fiction',450,5),
	(106,'Hamlet','William Shakespeare','Fiction',300,2),
	(107,'Data Science','Andrew Ng','Technology',700,3),
	(108,'Machine Learning','Tom Mitchell','Technology',800,1),
	(109,'C Programming','Dennis Ritchie','Programming',400,2),
	(110,'The Alchemist','Paulo Coelho','Fiction',350,4);
    
insert into issues(issue_id,member_id,book_id,issue_date,due_date,return_date)values
	(1,1,101,'2026-09-01','	2026-09-15','2026-09-14'),
	(2,2,101,'2026-09-02','2026-09-16','2026-09-20'),
	(3,3,102,'2026-09-03','2026-09-17',NULL),
	(4,	1,103,'	2026-09-04','2026-09-18','2026-09-25'),
	(5,	4,101,'	2026-09-05','2026-09-19','2026-09-19'),
	(6,	5,104,'	2026-09-06','2026-09-20','2026-09-22'),
	(7,	6,105,'	2026-09-07','2026-09-21',NULL),
	(8,	7,106,'2026-09-08','2026-09-22','2026-09-21'),
	(9,	1,101,'2026-09-09','2026-09-23','2026-09-28'),
	(10,2,107,'	2026-09-10','2026-09-24','2026-09-24'),
	(11,8,108,'	2026-09-11','2026-09-25',NULL),
	(12,3,101,'	2026-09-12','2026-09-26','2026-09-30'),
	(13,5,109,'	2026-09-13','2026-09-27',NULL),
	(14,6,101,'	2026-09-14','2026-09-28','2026-10-02'),
	(15,2,102,'	2026-09-15','2026-09-29','2026-10-01'),
	(16,8,101,'2026-09-16','2026-10-05',NULL);
select *from members;
select *from books;
select *from issues;

#c2.  counts
select count(*) from members;
select count(*) from books;
select count(*) from issues;

#c3. titles and total copies
select category,count(*) as titles, sum(copies_available) as copies
from books
GROUP BY category;

#c4. top5 borrowed books
select book_id,count(*)as borrowed
from issues
GROUP BY book_id
ORDER BY borrowed DESC LIMIT 5;

#c5. never borrowed a book
select m.member_id, m.member_name 
from  members m
LEFT JOIN issues i
ON m.member_id = i.member_id
WHERE i.member_id IS NULL;

#c6. books currently issued
SELECT m.member_name,
       b.title,
       i.due_date
FROM issues i
JOIN members m
ON i.member_id = m.member_id
JOIN books b
ON i.book_id = b.book_id
WHERE i.return_date IS NULL;

#c7. late returns with fine (rs 2 per day)
SELECT member_id,book_id,due_date,return_date,
       DATEDIFF(return_date, due_date) AS days_late,
       DATEDIFF(return_date, due_date) * 2 AS fine
FROM issues
WHERE return_date > due_date;

#c8. total fine per member
SELECT member_id,
       SUM(DATEDIFF(return_date, due_date) * 2) AS total_fine
FROM issues
WHERE return_date > due_date
GROUP BY member_id;

#c9. student vs faculty
SELECT m.member_type,
       COUNT(*) AS books_borrowed
FROM members m
JOIN issues i
ON m.member_id = i.member_id
GROUP BY m.member_type;

#c10. rank members
SELECT member_id,COUNT(*) AS books_borrowed,RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_no
FROM issues
GROUP BY member_id;

#c11. issues per category
SELECT b.category,
       COUNT(*) AS total_issues
FROM books b
JOIN issues i
ON b.book_id = i.book_id
GROUP BY b.category
ORDER BY total_issues DESC
LIMIT 1;

#c12. zero copy available and pending
SELECT book_id, title
FROM books
WHERE copies_available = 0
AND book_id IN
(
    SELECT book_id FROM issues WHERE return_date IS NULL
);

#c13. stored procedure
DELIMITER //

CREATE PROCEDURE member_history(IN id INT)
BEGIN

    SELECT b.title,
           i.issue_date,
           i.due_date,
           i.return_date
    FROM issues i
    JOIN books b
    ON i.book_id = b.book_id
    WHERE i.member_id = id;

END //

DELIMITER ;
CALL member_history(1);


#c14. trigger
DELIMITER //

CREATE TRIGGER reduce_copy
AFTER INSERT ON issues
FOR EACH ROW
BEGIN

    UPDATE books
    SET copies_available = copies_available - 1
    WHERE book_id = NEW.book_id;

END //

DELIMITER ;
SELECT title, copies_available FROM books WHERE book_id = 103;
INSERT INTO issues(issue_id, member_id, book_id, issue_date, due_date, return_date)
VALUES(17, 7, 103, '2026-11-10', '2026-11-24', NULL);
SELECT title, copies_available FROM books WHERE book_id = 103;
