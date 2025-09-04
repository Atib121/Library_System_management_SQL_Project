# 📚 Library Management System (MySQL Project)

## 🔹 Overview
This project is a **Library Management System** built using **MySQL**.  
It is designed to simulate real-world library operations such as managing books, members, employees, transactions, overdue tracking, and revenue reporting.  

The system enables:  
- ✅ Managing books, categories, and availability  
- ✅ Issuing and returning books  
- ✅ Tracking overdue books and fines  
- ✅ Managing members, employees, and branches  
- ✅ Generating reports for performance and revenue insights  

---

## 🔹 Database Design
The project includes the following key tables:  
- **book** – Stores book details like ISBN, title, category, price, and status  
- **branch** – Stores branch locations and managers  
- **employees** – Stores employee information and their assigned branches  
- **members** – Stores member details and registration data  
- **issued_status** – Tracks book issues with member and employee details  
- **return_status** – Tracks returned books with condition updates  

---

## 🔹 Key SQL Features & Queries
Some highlights of the project:  

1. **Insert & Update Operations** – Adding new books, updating member addresses, deleting issued records  
2. **Issued & Returned Books** – Queries to track issued books, returned books, and pending returns  
3. **Overdue Tracking** – Identifying books not returned within the 30-day period  
4. **Active Members** – Creating tables of members who borrowed books in the last 2 months  
5. **Branch Performance Report** – Number of books issued/returned and revenue per branch  
6. **Top Employees** – Ranking employees by number of book issues handled  
7. **Revenue Analysis** – Total revenue generated per category and rental price thresholds  

---

## 🔹 Sample Queries
- 📌 List members who have issued more than one book  
- 📌 Generate a branch-wise performance report  
- 📌 Identify overdue members and days overdue  
- 📌 Create summary tables using **CTAS**  
- 📌 Find top 3 employees who processed the most issues  

---

## 🔹 Dataset
Data is **synthetic** and created as part of this project for simulation purposes.  

---

## 🔹 How to Run
1. Clone this repository  
   ```bash
   git clone https://github.com/your-username/library-management-system.git

