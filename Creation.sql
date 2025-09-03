CREATE TABLE Restaurants (
	RestaurantId INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100) NOT NULL,
	Address NVARCHAR(250) NOT NULL,
	PhoneNumber NVARCHAR(25),
	OpeningHours VARCHAR(50)
);

CREATE TABLE MenuItems (	
	ItemId  INT PRIMARY KEY IDENTITY(1,1),
	RestaurantId INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	Description NVARCHAR(250),
	Price DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId)
);

CREATE TABLE Employees (
	EmployeeId  INT PRIMARY KEY IDENTITY(1,1),
	RestaurantId INT NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Position NVARCHAR(25) NOT NULL,
	FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId)
);

CREATE TABLE Customers (
	CustomerId INT PRIMARY KEY IDENTITY(1,1),
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Email NVARCHAR(250),
	PhoneNumber NVARCHAR(25) NOT NULL
);

CREATE TABLE RestaurantTables (
	TableId  INT PRIMARY KEY IDENTITY(1,1),
	RestaurantId INT NOT NULL,
	Capacity INT NOT NULL,
	FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId)
);

CREATE TABLE Reservations (
	ReservationId  INT PRIMARY KEY IDENTITY(1,1),
	CustomerId INT NOT NULL,
	RestaurantId INT NOT NULL,
	TableId INT NOT NULL,
	ReservationDate DATETIME NOT NULL,
	PartySize INT NOT NULL,
	FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
	FOREIGN KEY (RestaurantId) REFERENCES Restaurants(RestaurantId),
	FOREIGN KEY (TableId) REFERENCES RestaurantTables(TableId)
);

CREATE TABLE Orders (
	OrderId  INT PRIMARY KEY IDENTITY(1,1),
	ReservationId INT NOT NULL,
	EmployeeId INT NOT NULL,
	OrderDate DATETIME NOT NULL,
	TotalAmount DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId),
	FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId)
);

CREATE TABLE OrderItems (
	OrderItemId  INT PRIMARY KEY IDENTITY(1,1),
	OrderId INT NOT NULL,
	ItemId INT NOT NULL,
	Quantity INT NOT NULL,
	FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
	FOREIGN KEY (ItemId) REFERENCES MenuItems(ItemId)
);