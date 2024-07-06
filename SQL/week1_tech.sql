DROP TABLE IF EXISTS dbo.Customers_SS;
CREATE TABLE dbo.Customers_SS(

 CustomerID INT NOT NULL IDENTITY PRIMARY KEY ,
 FirstName varchar(255),
 LastName varchar(255),
 Email varchar(255),
 Phone varchar(255)

);


DROP TABLE IF EXISTS dbo.Products_SS;
CREATE TABLE dbo.Products_SS(

 ProductID INT NOT NULL IDENTITY PRIMARY KEY ,
 ProductName varchar(255),
 Price real,
 StockQuantity int

);

DROP TABLE IF EXISTS dbo.Orders_SS;
CREATE TABLE dbo.Orders_SS(

 OrderID INT NOT NULL IDENTITY PRIMARY KEY ,
 CustomerID INT FOREIGN KEY REFERENCES Customers_SS(CustomerID),
 ProductID INT FOREIGN KEY REFERENCES Products_SS(ProductID),
 OrderDate Date,
 Quantity int

);


ALTER TABLE Customers_SS
ADD DateOfBirth date;

ALTER TABLE Products_SS
ADD Category varchar(255);

SET IDENTITY_INSERT Customers_SS ON

DROP PROCEDURE IF EXISTS dbo.temp;
CREATE PROCEDURE temp
AS
BEGIN
   INSERT INTO dbo.Customers_SS(CustomerID,FirstName,LastName,Email,Phone,DateOfBirth)values('1','John','Smith','jsmith@gmail.com','555-5555','01-01-23')
END;

EXEC temp;