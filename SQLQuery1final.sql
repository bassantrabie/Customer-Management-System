CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY, 
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20),
    DateOfBirth DATE,
    Gender VARCHAR(10)
);
CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL, -- Keep this column to later add FK
    Street VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL, -- Reference to Customers table
    TransactionDate DATETIME NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(50),
    Status VARCHAR(20), -- e.g., Completed, Pending, Refunded
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE TransactionDetails (
    TransactionDetailID INT PRIMARY KEY IDENTITY(1,1),
    TransactionID INT NOT NULL, -- Reference to Transactions table
    ProductID INT NOT NULL, -- Reference to Products table
    Quantity INT NOT NULL,
    PriceAtTransaction DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE CustomerInteractions (
    InteractionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL, -- Reference to Customers table
    InteractionType VARCHAR(50), -- e.g., Support Call, Feedback, Email
    InteractionDate DATETIME NOT NULL,
    InteractionDetails TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

ALTER TABLE Addresses
ADD CONSTRAINT FK_Customers_Addresses FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID);

-- Insert 1,000 random records into Customers
DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN
    INSERT INTO Customers (CustomerID, FirstName, LastName, Email, PhoneNumber, DateOfBirth, Gender)
    VALUES (
        @Counter,
        CONCAT('FirstName', @Counter),
        CONCAT('LastName', @Counter),
        CONCAT('user', @Counter, '@gmail.com'),
        CASE WHEN RAND() > 0.2 THEN CONCAT('555-', FORMAT((RAND() * 9000000) + 1000000, '000-0000')) ELSE NULL END, -- 20% chance of NULL
        CASE WHEN RAND() > 0.3 THEN DATEADD(YEAR, -FLOOR(RAND() * 50 + 18), GETDATE()) ELSE NULL END, -- Random age between 18 and 68, 30% chance of NULL
        CASE WHEN RAND() > 0.1 THEN CASE WHEN RAND() > 0.5 THEN 'Male' ELSE 'Female' END ELSE NULL END -- 10% chance of NULL
    );
    SET @Counter = @Counter + 1;
END;

-- Insert 1,000 random records into Addresses
DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN
    INSERT INTO Addresses (CustomerID, Street, City, State, PostalCode, Country)
    VALUES (
        FLOOR(RAND() * 1000) + 1, -- Random CustomerID between 1 and 1000
        CONCAT('Street ', @Counter),
        CONCAT('City', FLOOR(RAND() * 100) + 1),
        CASE WHEN RAND() > 0.2 THEN CONCAT('State', FLOOR(RAND() * 50) + 1) ELSE NULL END, -- 20% chance of NULL
        CASE WHEN RAND() > 0.1 THEN FORMAT(FLOOR(RAND() * 90000) + 10000, '00000') ELSE NULL END, -- 10% chance of NULL
        CASE WHEN RAND() > 0.05 THEN CONCAT('Country', FLOOR(RAND() * 100) + 1) ELSE NULL END -- 5% chance of NULL
    );
    SET @Counter = @Counter + 1;
END;

-- Insert 1,000 random records into Products
DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN
    INSERT INTO Products (ProductName, Category, Price, StockQuantity)
    VALUES (
        CONCAT('Product', @Counter),
        CASE WHEN RAND() > 0.2 THEN CONCAT('Category', FLOOR(RAND() * 10) + 1) ELSE NULL END, -- 20% chance of NULL
        CAST(RAND() * 500 + 10 AS DECIMAL(10, 2)), -- Random price between 10 and 510
        FLOOR(RAND() * 100) + 1 -- Random stock quantity between 1 and 100
    );
    SET @Counter = @Counter + 1;
END;

-- Insert 1,000 random records into Transactions
DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN
    INSERT INTO Transactions (CustomerID, TransactionDate, TotalAmount, PaymentMethod, Status)
    VALUES (
        FLOOR(RAND() * 1000) + 1, -- Random CustomerID between 1 and 1000
        DATEADD(DAY, -RAND() * 365, GETDATE()), -- Random date within the last year
        CAST(RAND() * 1000 + 50 AS DECIMAL(10, 2)), -- Random total amount between 50 and 1050
        CASE WHEN RAND() > 0.1 THEN CASE FLOOR(RAND() * 3) WHEN 0 THEN 'Credit Card' WHEN 1 THEN 'Debit Card' ELSE 'PayPal' END ELSE NULL END, -- 10% chance of NULL
        CASE FLOOR(RAND() * 3) WHEN 0 THEN 'Completed' WHEN 1 THEN 'Pending' ELSE 'Refunded' END
    );
    SET @Counter = @Counter + 1;
END;

-- Insert 1,000 random records into TransactionDetails
DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN
    INSERT INTO TransactionDetails (TransactionID, ProductID, Quantity, PriceAtTransaction)
    VALUES (
        FLOOR(RAND() * 1000) + 1, -- Random TransactionID between 1 and 1000
        FLOOR(RAND() * 1000) + 1, -- Random ProductID between 1 and 1000
        FLOOR(RAND() * 10) + 1, -- Random quantity between 1 and 10
        CAST(RAND() * 500 + 10 AS DECIMAL(10, 2)) -- Random price between 10 and 510
    );
    SET @Counter = @Counter + 1;
END;

-- Insert 1,000 random records into CustomerInteractions
DECLARE @Counter INT = 1;

WHILE @Counter <= 1000
BEGIN
    INSERT INTO CustomerInteractions (CustomerID, InteractionType, InteractionDate, InteractionDetails)
    VALUES (
        FLOOR(RAND() * 1000) + 1, -- Random CustomerID between 1 and 1000
        CASE FLOOR(RAND() * 3) WHEN 0 THEN 'Support Call' WHEN 1 THEN 'Feedback' ELSE 'Email' END,
        DATEADD(DAY, -RAND() * 365, GETDATE()), -- Random date within the last year
        CONCAT('Interaction details for record ', @Counter)
    );
    SET @Counter = @Counter + 1;
END;
-- First query
SELECT CustomerID, FirstName, LastName, Email, PhoneNumber, Gender, DateOfBirth
FROM Customers;

-- Second query
SELECT C.CustomerID, C.FirstName, C.LastName, COUNT(A.AddressID) AS AddressCount
FROM Customers C
JOIN Addresses A ON C.CustomerID = A.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName
HAVING COUNT(A.AddressID) > 1;

-- Third query
SELECT C.CustomerID, C.FirstName, C.LastName, SUM(T.TotalAmount) AS TotalSpent
FROM Customers C
JOIN Transactions T ON C.CustomerID = T.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY TotalSpent DESC;

-- Fourth query
SELECT TOP 5 P.ProductName, SUM(TD.Quantity) AS TotalQuantitySold
FROM Products P
JOIN TransactionDetails TD ON P.ProductID = TD.ProductID
GROUP BY P.ProductName
ORDER BY TotalQuantitySold DESC;

-- Fifth query
SELECT 
    DATEPART(YEAR, TransactionDate) AS Year, 
    DATEPART(MONTH, TransactionDate) AS Month, 
    COUNT(TransactionID) AS TotalTransactions, 
    SUM(TotalAmount) AS TotalSales
FROM Transactions
GROUP BY DATEPART(YEAR, TransactionDate), DATEPART(MONTH, TransactionDate)
ORDER BY Year, Month;

-- Sixth query
SELECT PaymentMethod, AVG(TotalAmount) AS AverageTransactionAmount
FROM Transactions
GROUP BY PaymentMethod;

-- Seventh query
SELECT ProductID, ProductName, StockQuantity
FROM Products
WHERE StockQuantity < 10;

-- Eighth query
SELECT C.CustomerID, C.FirstName, C.LastName, 
       COUNT(CI.InteractionID) AS TotalInteractions,
       MAX(CI.InteractionDate) AS LastInteractionDate
FROM Customers C
JOIN CustomerInteractions CI ON C.CustomerID = CI.CustomerID
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY TotalInteractions DESC;

-- Ninth query
SELECT C.CustomerID, C.FirstName, C.LastName
FROM Customers C
LEFT JOIN Transactions T ON C.CustomerID = T.CustomerID
WHERE T.TransactionID IS NULL;

-- Tenth query
SELECT T.TransactionID, T.TransactionDate, COUNT(TD.ProductID) AS ProductCount
FROM Transactions T
JOIN TransactionDetails TD ON T.TransactionID = TD.TransactionID
GROUP BY T.TransactionID, T.TransactionDate
HAVING COUNT(TD.ProductID) > 1
ORDER BY ProductCount DESC;

-- Eleventh query
UPDATE Customers
SET PhoneNumber = '555-123-4567'
WHERE CustomerID = 1;

-- Twelfth query
SELECT CustomerID, FirstName, LastName, PhoneNumber
FROM Customers
WHERE CustomerID = 1;

-- Thirteenth query
CREATE VIEW ProductSales AS
SELECT P.ProductID, P.ProductName, SUM(TD.Quantity) AS TotalQuantitySold
FROM Products P
JOIN TransactionDetails TD ON P.ProductID = TD.ProductID
GROUP BY P.ProductID, P.ProductName;

-- Fourteenth query
SELECT * FROM ProductSales;

-- Fifteenth query
CREATE FUNCTION CalculateAge (@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    SET @Age = DATEDIFF(YEAR, @DateOfBirth, GETDATE());
    
    -- Subtract 1 if the customer's birthday hasn't occurred yet this year
    IF (DATEADD(YEAR, @Age, @DateOfBirth) > GETDATE())
        SET @Age = @Age - 1;
    
    RETURN @Age;
END;

-- Sixteenth query
SELECT CustomerID, FirstName, LastName, dbo.CalculateAge(DateOfBirth) AS Age
FROM Customers;

-- Seventeenth query
ALTER TABLE Customers
ADD LoyaltyPoints INT DEFAULT 0;

-- Eighteenth query
SELECT CustomerID, FirstName, LastName, LoyaltyPoints
FROM Customers;
