-- Part: 1
SELECT * FROM Reservations
WHERE CustomerId = 231;

-- Part: 2
SELECT * FROM Employees
WHERE Position = 'Manager';

-- Part: 3
SELECT * FROM Orders 
JOIN OrderItems ON Orders.OrderId = OrderItems.OrderId
JOIN MenuItems ON OrderItems.ItemId = MenuItems.ItemId 
WHERE ReservationId = 280;

-- Part: 4
SELECT * FROM MenuItems 
JOIN OrderItems ON MenuItems.ItemId = OrderItems.ItemId
JOIN Orders ON Orders.OrderId  = OrderItems.OrderId  
WHERE ReservationId = 280;

-- Part: 5
SELECT E.EmployeeId, E.FirstName, AVG(O.TotalAmount) [Average Order Amount]
FROM Employees E
JOIN Orders O ON E.EmployeeId = O.EmployeeId
GROUP BY E.EmployeeId, E.FirstName;

-- Part: 6
DROP VIEW ReservationsReportView;
CREATE VIEW ReservationsReportView AS
SELECT
    R.ReservationId,
    R.ReservationDate,
    R.PartySize,
    C.CustomerId, 
    C.FirstName, 
    C.LastName, 
    C.Email, 
    C.PhoneNumber AS [Customer Phone],
    Res.RestaurantId, 
    Res.Name, 
    Res.Address, 
    Res.PhoneNumber AS [Restaurant Phone],
    Res.OpeningHours 
FROM Reservations R
JOIN Customers C ON R.CustomerId = C.CustomerId
JOIN Restaurants Res ON R.RestaurantId = Res.RestaurantId;

SELECT * 
FROM ReservationsReportView
ORDER BY ReservationDate;

-- Part: 7
DROP VIEW EmployeesReportView;
CREATE VIEW EmployeesReportView AS
SELECT 
    E.EmployeeId,
    E.FirstName,
    E.LastName,
    E.Position,
    Res.RestaurantId,
    Res.Name,
    Res.Address,
    Res.PhoneNumber,
    Res.OpeningHours
FROM Employees E
JOIN Restaurants Res ON E.RestaurantId = Res.RestaurantId;

SELECT * 
FROM EmployeesReportView
ORDER BY RestaurantId

-- Part: 8
WITH ReservationsOrders AS (
    SELECT ReservationId, COUNT(OrderId) AS NumOrders
    FROM Orders
    GROUP BY ReservationId
)

SELECT * FROM ReservationsOrders RO
JOIN Reservations R ON RO.ReservationId = R.ReservationId
WHERE ro.NumOrders >= 2
ORDER BY ro.NumOrders DESC;

-- Part: 9
SELECT RES.RestaurantId, RES.Name, COUNT(*) [Number of Reservations],
    DENSE_RANK() OVER (ORDER BY COUNT(*)) AS [Number of Reservations Rank]
FROM Restaurants RES
JOIN Reservations R ON RES.RestaurantId = R.RestaurantId
GROUP BY RES.RestaurantId, RES.Name;

-- Part: 10
WITH ItemFrequency AS (
    SELECT R.RestaurantId, MI.ItemId, MI.Name, SUM(Quantity) [Times Ordered],
        ROW_NUMBER() OVER (PARTITION BY R.RestaurantId ORDER BY SUM(OI.Quantity) DESC) AS ranking
    FROM MenuItems MI
    JOIN OrderItems OI ON MI.ItemId = OI.ItemId
    JOIN Restaurants R ON MI.RestaurantId = R.RestaurantId
    JOIN Orders O ON OI.OrderId = O.OrderId
    WHERE MONTH(O.OrderDate) = 10 
    GROUP BY R.RestaurantId, MI.ItemId, MI.Name
)

SELECT *
FROM ItemFrequency
WHERE ranking = 1;

-- Part: 11
CREATE FUNCTION fn_CalculateRevenue (@RestaurantId INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total = SUM(O.TotalAmount)
    FROM Orders O
    JOIN Reservations R ON O.ReservationId = R.ReservationId
    JOIN Restaurants RES ON R.RestaurantId = RES.RestaurantId
    WHERE RES.RestaurantId = @RestaurantId;

    RETURN ISNULL(@Total, 0);
END;

SELECT dbo.fn_CalculateRevenue(10) AS [Total Restaurant Revenue];

-- Part: 12
DROP FUNCTION fn_CalculateEmployeeSalary;
CREATE FUNCTION fn_CalculateEmployeeSalary (@EmployeeId INT)
RETURNS INT
AS
BEGIN
    DECLARE @Salary INT;
    DECLARE @Rank INT;

    IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeId = @EmployeeId AND Position = 'Manager')
        SET @Rank = 5;
    ELSE IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeId = @EmployeeId AND Position = 'Chef')
        SET @Rank = 4;
    ELSE IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeId = @EmployeeId AND Position = 'Waiter')
        SET @Rank = 3;
    ELSE IF EXISTS (SELECT 1 FROM Employees WHERE EmployeeId = @EmployeeId AND Position = 'Host')
        SET @Rank = 2;

    SELECT @Salary = COUNT(O.TotalAmount) * @Rank
    FROM Employees E
    JOIN Orders O ON O.EmployeeId = E.EmployeeId
    WHERE E.EmployeeId = @EmployeeId;

    RETURN ISNULL(@Salary, 0);
END;

SELECT dbo.fn_CalculateEmployeeSalary(10) AS [Employee's Salary];

-- Part: 13
CREATE PROCEDURE sp_ResrvedTablesReport @StartDate DATETIME, @EndDate DATETIME
AS
BEGIN
    SELECT * FROM RestaurantTables RT
    JOIN Reservations R ON RT.TableId = R.TableId
    WHERE R.ReservationDate >= @StartDate AND R.ReservationDate <= @EndDate
END;

EXEC sp_ResrvedTablesReport @StartDate = '2025-09-04', @EndDate = '2025-09-5';
