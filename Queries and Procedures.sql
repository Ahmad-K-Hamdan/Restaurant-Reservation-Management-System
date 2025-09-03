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
