-- Create Database
CREATE DATABASE OnlineBookstore;

-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT *FROM BOOKS WHERE GENRE='Fiction';

-- 2) Find books published after the year 1950:
SELECT *FROM BOOKS WHERE PUBLISHED_YEAR>1950;

-- 3) List all customers from the Canada:
SELECT *FROM CUSTOMERS WHERE COUNTRY='Canada';

-- 4) Show orders placed in November 2023:
SELECT *FROM ORDERS WHERE ORDER_DATE BETWEEN '2023-11-1' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(STOCK) AS TOTAL_STOCK FROM BOOKS;

-- 6) Find the details of the most expensive book:
SELECT *FROM BOOKS ORDER BY PRICE DESC LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT *FROM ORDERS WHERE QUANTITY>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT *FROM ORDERS WHERE TOTAL_AMOUNT>20;


-- 9) List all genres available in the Books table:
SELECT DISTINCT GENRE FROM BOOKS;


-- 10) Find the book with the lowest stock:
SELECT *FROM BOOKS ORDER BY STOCK LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE FROM ORDERS;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT GENRE,SUM(QUANTITY) AS TOTAL_BOOKS FROM ORDERS JOIN BOOKS ON ORDERS.BOOK_ID=BOOKS.BOOK_ID GROUP BY GENRE; 


-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(PRICE)AS AVERAGE_BOOK_PRICE FROM BOOKS WHERE GENRE='Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT O.CUSTOMER_ID,C.NAME,COUNT(O.ORDER_ID)
	 AS ORDER_COUNT FROM ORDERS O JOIN CUSTOMERS C ON O.CUSTOMER_ID=C.CUSTOMER_ID 
	GROUP BY O.CUSTOMER_ID,C.NAME HAVING COUNT(ORDER_ID)>=2;

-- 4) Find the most frequently ordered book:
SELECT O.BOOK_ID,B.TITLE,COUNT(O.ORDER_ID) AS ORDER_COUNT FROM ORDERS O JOIN
	BOOKS B ON O.BOOK_ID=B.BOOK_ID GROUP BY O.BOOK_ID,B.TITLE
	ORDER BY COUNT(O.ORDER_ID) DESC LIMIT 1;



-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT *FROM BOOKS WHERE GENRE='Fantasy' ORDER BY PRICE DESC LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;





-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;








