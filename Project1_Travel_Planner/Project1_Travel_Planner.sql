USE master
-- Table Creation Script

-- Flights Table
CREATE TABLE Flights (
    FlightID INT PRIMARY KEY,
    Airline VARCHAR(50),
    DepartureCity VARCHAR(50),
    ArrivalCity VARCHAR(50),
    DepartureDate DATE,
    ArrivalDate DATE,
    SeatType VARCHAR(20)
);

-- Accommodations Table
CREATE TABLE Accommodations (
    AccommodationID INT PRIMARY KEY,
    HotelName VARCHAR(50),
    CheckInDate DATE,
    CheckOutDate DATE,
    RoomType VARCHAR(20),
    Amenities VARCHAR(100)
);

-- Activities Table
CREATE TABLE Activities (
    ActivityID INT PRIMARY KEY,
    ActivityName VARCHAR(50),
    Location VARCHAR(50),
    Date DATE,
    Time TIME,
    Cost DECIMAL(10, 2)
);

-- Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50),
    Password VARCHAR(50),
    Email VARCHAR(100),
    Preferences VARCHAR(200)
);

-- Itineraries Table
CREATE TABLE Itineraries (
    ItineraryID INT PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    FlightID INT FOREIGN KEY REFERENCES Flights(FlightID),
    AccommodationID INT FOREIGN KEY REFERENCES Accommodations(AccommodationID),
    ActivityID INT FOREIGN KEY REFERENCES Activities(ActivityID),
    DateCreated DATETIME
);

-- Destinations Table
CREATE TABLE Destinations (
    DestinationID INT PRIMARY KEY,
    City VARCHAR(50),
    Country VARCHAR(50),
    Description VARCHAR(200)
);

-- Transportation Table
CREATE TABLE Transportation (
    TransportID INT PRIMARY KEY,
    Mode VARCHAR(50),
    DepartureLocation VARCHAR(50),
    ArrivalLocation VARCHAR(50),
    DepartureTime TIME,
    ArrivalTime TIME
);

-- Expenses Table
CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY,
    ItineraryID INT FOREIGN KEY REFERENCES Itineraries(ItineraryID),
    Category VARCHAR(50),
    Amount DECIMAL(10, 2),
    Date DATE
);


-- Data Insertion Script

-- Inserting sample data into Flights Table
INSERT INTO Flights (FlightID, Airline, DepartureCity, ArrivalCity, DepartureDate, ArrivalDate, SeatType)
VALUES
(1, 'Airline1', 'CityA', 'CityB', '2023-01-01', '2023-01-02', 'Economy'),
(2, 'Airline2', 'CityB', 'CityC', '2023-02-01', '2023-02-02', 'Business');
-- Add more rows as needed

-- Inserting sample data into Accommodations Table
INSERT INTO Accommodations (AccommodationID, HotelName, CheckInDate, CheckOutDate, RoomType, Amenities)
VALUES
(1, 'Hotel1', '2023-01-01', '2023-01-03', 'Single', 'Wi-Fi, TV'),
(2, 'Hotel2', '2023-02-01', '2023-02-03', 'Double', 'Pool, Gym');
-- Add more rows as needed

-- Inserting sample data into Activities Table
INSERT INTO Activities (ActivityID, ActivityName, Location, Date, Time, Cost)
VALUES
(1, 'Sightseeing', 'CityA', '2023-01-02', '10:00:00', 50.00),
(2, 'Museum Visit', 'CityB', '2023-02-02', '15:00:00', 30.00);
-- Add more rows as needed

-- Inserting sample data into Users Table
INSERT INTO Users (UserID, Username, Password, Email, Preferences)
VALUES
(1, 'User1', 'password1', 'user1@example.com', 'Window seat, Non-smoking'),
(2, 'User2', 'password2', 'user2@example.com', 'Vegetarian meals');
-- Add more rows as needed

-- Inserting sample data into Itineraries Table
INSERT INTO Itineraries (ItineraryID, UserID, FlightID, AccommodationID, ActivityID, DateCreated)
VALUES
(1, 1, 1, 1, 1, '2023-01-01 08:00:00'),
(2, 2, 2, 2, 2, '2023-02-01 10:00:00');
-- Add more rows as needed

-- Inserting sample data into Destinations Table
INSERT INTO Destinations (DestinationID, City, Country, Description)
VALUES
(1, 'CityA', 'CountryA', 'A beautiful city with rich history'),
(2, 'CityB', 'CountryB', 'A vibrant and cultural destination');
-- Add more rows as needed

-- Inserting sample data into Transportation Table
INSERT INTO Transportation (TransportID, Mode, DepartureLocation, ArrivalLocation, DepartureTime, ArrivalTime)
VALUES
(1, 'Train', 'CityA', 'CityB', '08:30:00', '12:00:00'),
(2, 'Bus', 'CityB', 'CityC', '14:00:00', '17:30:00');
-- Add more rows as needed

-- Inserting sample data into Expenses Table
INSERT INTO Expenses (ExpenseID, ItineraryID, Category, Amount, Date)
VALUES
(1, 1, 'Food', 25.00, '2023-01-02'),
(2, 2, 'Shopping', 50.00, '2023-02-02');
-- Add more rows as needed




-- Travel Summary View
IF OBJECT_ID('dbo.Travel_Summary', 'V') IS NOT NULL
    DROP VIEW dbo.Travel_Summary;
GO

CREATE VIEW Travel_Summary AS
SELECT
    I.ItineraryID,
    U.Username,
    F.Airline,
    F.DepartureCity,
    F.ArrivalCity,
    F.DepartureDate,
    F.ArrivalDate,
    A.HotelName,
    A.CheckInDate,
    A.CheckOutDate,
    AC.ActivityName,
    AC.Location,
    AC.Date AS ActivityDate
FROM Itineraries I
JOIN Users U ON I.UserID = U.UserID
JOIN Flights F ON I.FlightID = F.FlightID
JOIN Accommodations A ON I.AccommodationID = A.AccommodationID
JOIN Activities AC ON I.ActivityID = AC.ActivityID;
GO

-- Expense Report View
IF OBJECT_ID('dbo.Expense_Report', 'V') IS NOT NULL
    DROP VIEW dbo.Expense_Report;
GO

CREATE VIEW Expense_Report AS
SELECT
    E.ExpenseID,
    I.ItineraryID,
    U.Username,
    E.Category,
    E.Amount,
    E.Date
FROM Expenses E
JOIN Itineraries I ON E.ItineraryID = I.ItineraryID
JOIN Users U ON I.UserID = U.UserID;
GO

-- User Preferences View
IF OBJECT_ID('dbo.User_Preferences', 'V') IS NOT NULL
    DROP VIEW dbo.User_Preferences;
GO

CREATE VIEW User_Preferences AS
SELECT
    U.UserID,
    U.Username,
    U.Preferences
FROM Users U;
GO


SELECT *
FROM Expenses;