CREATE DATABASE JordanRaw;

USE JordanRaw;

CREATE TABLE Brands (
    BrandID INT AUTO_INCREMENT,
    BrandName VARCHAR(100),
    CountryOrigin VARCHAR(100),
    YearFounded YEAR,
    Founder VARCHAR(100),
    Headquarters VARCHAR(100),
    PRIMARY KEY (BrandID)
);
CREATE TABLE Sneakers (
    SneakerID INT AUTO_INCREMENT,
    BrandID INT,
    ModelName VARCHAR(100),
    ReleaseYear YEAR,
    Colorway VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10,2),
    ImageURL VARCHAR(255),
    PRIMARY KEY (SneakerID),
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
);
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT,
    SneakerID INT,
    Size DECIMAL(3,1),
    Quantity INT,
    PRIMARY KEY (InventoryID),
    FOREIGN KEY (SneakerID) REFERENCES Sneakers(SneakerID)
);
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    PRIMARY KEY (CustomerID)
);
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails (
    OrderDetailID INT AUTO_INCREMENT,
    OrderID INT,
    SneakerID INT,
    Quantity INT,
    Size DECIMAL(3,1),
    PRIMARY KEY (OrderDetailID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (SneakerID) REFERENCES Sneakers(SneakerID)
);

INSERT INTO Brands (BrandName, CountryOrigin, YearFounded, Founder, Headquarters)
VALUES 
('Nike', 'USA', 1964, 'Phil Knight, Bill Bowerman', 'Beaverton, Oregon'),
('Adidas', 'Germany', 1949, 'Adolf Dassler', 'Herzogenaurach, Germany'),
('Puma', 'Germany', 1948, 'Rudolf Dassler', 'Herzogenaurach, Germany'),
('New Balance', 'USA', 1906, 'William J. Riley', 'Boston, Massachusetts');

INSERT INTO Sneakers (BrandID, ModelName, ReleaseYear, Colorway, Description, Price, ImageURL)
VALUES
(1, 'Air Jordan 1', 1985, 'Black/Red', 'The first ever Air Jordan sneakers, also known as Banned.', 500.00, 'http://imageurl.com/nike-air-jordan-1'),
(2, 'Stan Smith', 1965, 'White/Green', 'One of the most iconic Adidas sneakers.', 80.00, 'http://imageurl.com/adidas-stan-smith'),
(3, 'Puma Suede', 1968, 'Blue/White', 'An iconic model from Puma.', 70.00, 'http://imageurl.com/puma-suede'),
(4, 'New Balance 574', 1988, 'Grey/White', 'Classic New Balance sneakers.', 75.00, 'http://imageurl.com/new-balance-574');

INSERT INTO Inventory (SneakerID, Size, Quantity)
VALUES
(1, 9.0, 10),
(1, 9.5, 8),
(2, 9.0, 15),
(2, 9.5, 15),
(3, 9.0, 12),
(3, 9.5, 15),
(4, 10.0, 10),
(4, 10.5, 15);

INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES
('John', 'Doe', 'johndoe@example.com', '123-456-7890'),
('Jane', 'Smith', 'janesmith@example.com', '098-765-4321'),
('James', 'Taylor', 'jamestaylor@example.com', '111-222-3333'),
('Emma', 'Johnson', 'emmajohnson@example.com', '444-555-6666');

INSERT INTO Orders (CustomerID, OrderDate)
VALUES
(1, '2023-06-01'),
(2, '2023-06-02'),
(3, '2023-06-03'),
(4, '2023-06-04');

INSERT INTO OrderDetails (OrderID, SneakerID, Quantity, Size)
VALUES
(1, 1, 1, 9.0),
(2, 2, 2, 9.5),
(3, 3, 1, 9.0),
(4, 4, 2, 10.5);

/*
List all sneakers for a specific brand.

Replace 'Nike' with the name of the brand whose sneakers you want to list.
*/
SELECT s.*
FROM Sneakers s
INNER JOIN Brands b ON s.BrandID = b.BrandID
WHERE b.BrandName = 'Nike';

/*
Find the total quantity of a specific sneaker in inventory.
Replace 'Air Jordan 1' with the name of the sneaker.
*/
SELECT SUM(i.Quantity)
FROM Inventory i
INNER JOIN Sneakers s ON i.SneakerID = s.SneakerID
WHERE s.ModelName = 'Air Jordan 1';

/*
List all orders by a specific customer.
Replace 'John Doe' with the name of the customer.
*/
SELECT o.*
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.FirstName = 'John' AND c.LastName = 'Doe';

/*
Find the total number of sneakers sold.
*/
SELECT SUM(od.Quantity)
FROM OrderDetails od;

/*
Find the most popular sneaker size.
*/
SELECT od.Size, COUNT(*) as num_orders
FROM OrderDetails od
GROUP BY od.Size
ORDER BY num_orders DESC
LIMIT 1;

/*
List all sneakers bought by a specific customer.
Replace 'John Doe' with the name of the customer.
*/
SELECT s.*
FROM Sneakers s
INNER JOIN OrderDetails od ON s.SneakerID = od.SneakerID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.FirstName = 'John' AND c.LastName = 'Doe';

/*
INNER JOIN

An INNER JOIN returns only the rows that match in both tables. Example 
that retrieves all the orders with their corresponding customer details.

This will return a list of orders, but only for orders where the 
CustomerID in the Orders table matches a CustomerID in the Customers table. 
If a customer hasn't made an order, they won't appear in this list.
*/
SELECT o.OrerID, c.FirstName, c.LastName, o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

/*
LEFT JOIN (or LEFT OUTER JOIN)

A LEFT JOIN returns all the rows from the left table, and the matched rows from the right table. 
If there's no match, the result is NULL on the right side. 
Here's an example that retrieves all customers and their orders (if any).
This will return a list of all customers, even if they haven't made an order. 
If a customer hasn't made an order, OrderDate will be NULL for them.
*/
SELECT c.FirstName, c.LastName, o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

/*
RIGHT JOIN (or RIGHT OUTER JOIN)

A RIGHT JOIN returns all the rows from the right table, and the matched rows from the left table. If there's no match, 
the result is NULL on the left side. Here's an example that retrieves all orders and their customers (if any).

This will return a list of all orders, even if they don't have a corresponding customer. 
If an order doesn't have a corresponding customer, FirstName and LastName will be NULL.

Note: RIGHT JOIN is not as commonly used as the other join types because you can always rewrite a query 
that uses RIGHT JOIN to use LEFT JOIN instead, 
just by switching the order of the tables.
*/
SELECT c.FirstName, c.LastName, o.OrderDate
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

/*
FULL JOINs in MySQL: As mentioned in the script, 
FULL JOINs are not supported in MySQL. But you can simulate a FULL JOIN using a combination of LEFT JOIN and UNION:
*/
SELECT c.FirstName, c.LastName, o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.FirstName, c.LastName, o.OrderDate
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

