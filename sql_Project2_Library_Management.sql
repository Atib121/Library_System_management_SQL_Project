# SQL Library Management project

use library;

create table book (isbn varchar(60), 
book_title	varchar(100), 
category varchar(100), 
rental_price int, 
status varchar(50), 
author varchar(50),
publisher varchar(60));

select * from book;

create table branch (branch_id	varchar(10) , manager_id varchar(50), branch_address varchar(150));

select * from branch;

create table employees (emp_id	varchar(60), emp_name varchar(100),	position varchar(100), salary int,	branch_id varchar(50));

create table issued_status (issued_id varchar(50), issued_member_id varchar(50), 
issued_book_name varchar(150),	issued_date	date ,issued_book_isbn varchar(60), 
issued_emp_id varchar(60));

create table members (member_id	varchar(60), member_name varchar(60), member_address varchar (100), reg_date date);

create table return_status (return_id varchar(50), issued_id varchar (50), 
return_book_name varchar(100), return_date date, return_book_isbn varchar(60));


alter table return_status
add column book_quality varchar(60) default('Good');

set sql_safe_updates = 0;

set sql_safe_updates = 1;

update return_status
set book_quality = 'Damaged'
where issued_id in ('IS112','IS117','IS118');

# Question no 1
insert into book values ("978-1-60129-456-2", 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


# Question 2
set sql_safe_updates = 0;
update members
set member_address = '125 Main St'
where member_id = 'C101';
set sql_safe_updates = 1;

# Question 3  Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issued_status
where issued_id = 'IS121';

# Question 4 
select issued_book_name 
from issued_status
where issued_emp_id = 'E101';

# Question 5 List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_member_id, e.emp_name, count(*) as books_issued
from issued_status isbn
join employees e on e.emp_id = isbn.issued_emp_id 
group by issued_member_id, e.emp_name
order by books_issued desc
limit 10;


# Question 6  Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

create table books_count
as
select b.isbn,
	   b.book_title,
       count(ist.issued_id) as books_issued_count
from book b
join issued_status ist on b.isbn = ist.issued_book_isbn
group by b.isbn, b.book_title
order by count(ist.issued_id) desc;

select count(*) from books_count;

# Question 7

select category, count(*) as books_count
from book
group by category
order by count(*) desc;

select category, book_title
from book
where category = 'classic';

# Question 8 

select b.category, sum(b.rental_price) as total_revenue, count(ist.issued_book_isbn) as cnt
from book b
join issued_status ist
on b.isbn=ist.issued_book_isbn
group by b.category
order by sum(b.rental_price) desc;

# Question 9 List Members Who Registered in the Last 180 Days:

with cte as
(select *, 
date_sub(curdate(),interval(5) month) as last_180_days
from members
where reg_date >= date_sub(curdate(),interval(6) month))
select * from cte ;



DELETE FROM members
WHERE member_id IN (
    SELECT member_id
    FROM (
        SELECT member_id
        FROM members
        GROUP BY member_id
        HAVING COUNT(*) > 1
        LIMIT 1
    ) AS temp
);

# Question 10 List Employees with Their Branch Manager's Name and their branch details:

select e1.*,b.branch_address,b.manager_id,e2.emp_name as manager_name
from employees e1
join branch b
on e1.branch_id = b.branch_id
join employees e2
on e2.emp_id = b.manager_id;

# Question 11 Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
drop table if exists books_rent_greater_then_7;
create table books_rent_greater_then_7
as
select isbn, book_title, category, concat("$ ",rental_price) as rent
from book
where rental_price > 7;
select * from books_rent_greater_then_7;

# Question 12  Retrieve the List of Books Not Yet Returned
select count(issued_id) from issued_status
union all
select count(issued_id) from return_status;

select issued_id
from issued_status
where issued_id not in (select issued_id from return_status);

select ist.issued_book_name
from issued_status ist
left join return_status rs on ist.issued_id = rs.issued_id
where rs.issued_id is null;

# Question 13 Write a query to identify members who have overdue books (assume a 30-day return period). 
-- Display the member's_id, member's name, book title, issue date, and days overdue.

select ist.issued_id, 
	   m.member_id, 
	   m.member_name, 
       ist.issued_book_name,
       issued_date,
       date_add(issued_date, interval(1) month) as due_date,
       rst.return_date,
       datediff(rst.return_date, date_add(issued_date, interval(1) month)) as days_overdue
from issued_status ist
join members m on m.member_id = ist.issued_member_id
left join return_status rst on ist.issued_id = rst.issued_id;

with not_returned as (select issued_id
						from issued_status
						where issued_id not in (select issued_id from return_status))
select nr.issued_id, issued_book_name, issued_date,
	   date_add(issued_date, interval(1) month) as due_date
       from not_returned nr
       join issued_status ist on nr.issued_id = ist.issued_id;
       
# Question 14 Write a query to update the status of books in the books table to "Yes" when they are returned 
  

with cte as 
(select ist.issued_member_id,
	   case when return_date is not null then 'Yes'
       else 'No' 
       end as Book_returned_status
from issued_status ist
left join return_status rst  on ist.issued_id = rst.issued_id)
select issued_member_id, Book_returned_status, count(*) as Books_count
from cte
group by issued_member_id, Book_returned_status
order by issued_member_id;

# Question 15 Create a query that generates a performance report for each branch, 
-- showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
drop table if exists branch_report ;
create table branch_report
as
select  e.branch_id, br.branch_address, e2.emp_name as manager_name,
count(ist.issued_id) as book_issue_cnt, 
count(return_id) as returned_cnt, 
sum(b.rental_price) as total_revenue
from issued_status ist
left join return_status rst  on ist.issued_id = rst.issued_id
join employees e on ist.issued_emp_id = e.emp_id
join book b on ist.issued_book_isbn = b.isbn
join branch br on e.branch_id = br.branch_id
join employees e2 on e2.emp_id = br.manager_id
group by  e.branch_id, br.branch_address, e2.emp_name;

# Question 16 CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
-- containing members who have issued at least one book in the last 2 months.

create table active_users
as
select m.member_id,m.member_name
from issued_status ist
join members m on ist.issued_member_id = m.member_id
where date_sub(curdate(), interval(5) month) <= ist.issued_date
group by m.member_id,m.member_name;

select * from active_users;

# Question 17  Write a query to find the top 3 employees who have processed the most book issues. 
-- Display the employee name, number of books processed, and their branch.
 
 select e.branch_id, e.emp_id, e.emp_name as employee_name, count(ist.issued_id) as Books_issued
 from issued_status ist
 join employees e on ist.issued_emp_id = e.emp_id
 group by e.branch_id, e.emp_id, e.emp_name
 order by count(ist.issued_id) desc
 limit 3;
 

