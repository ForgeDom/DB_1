create database Airport;
go
use Airport;
go

create table Passengers(
    PassengerID int not null primary key identity (1,1),
    FirstName nvarchar(20) not null,
    LastName nvarchar(20) not null,
    PassportNumber nvarchar(20) not null unique
);
go

create table Flights(
    FlightID int not null primary key identity (1,1),
    FlightNumber nvarchar(10) not null,
    DepartureCity nvarchar(100) not null,
    ArrivalCity nvarchar(100) not null,
    DepartureTime datetime not null,
    ArrivalTime datetime not null,
    Duration as datediff(minute, DepartureTime, ArrivalTime) persisted,
    constraint CHK_Duration check (ArrivalTime > DepartureTime)
);
go

create table Tickets(
    TicketID int not null primary key identity(1,1),
    FlightID int not null,
    PassengerID int not null,
    Class nvarchar(10) not null check (Class in ('Business', 'Economy')),
    Price money not null check (Price > 0),
    PurchaseDate datetime not null,
    SeatNumber int not null,
    foreign key (FlightID) references Flights(FlightID),
    foreign key (PassengerID) references Passengers(PassengerID)
);
go

create table FlightTimeChangesLog (
    LogID int not null primary key identity(1,1),
    FlightID int not null,
    OldDepartureTime datetime,
    NewDepartureTime datetime,
    OldArrivalTime datetime,
    NewArrivalTime datetime,
    ChangeDate datetime not null
);
go

create trigger trg_PreventPastFlightTicketPurchase
on Tickets
after insert
as
begin
    if exists (
        select 1 from Flights f
        join inserted i on f.FlightID = i.FlightID
        where f.DepartureTime < getdate()
    )
    begin
        raiserror('Cannot purchase ticket for a flight that has already departed.', 16, 1);
        rollback transaction;
    end
end;
go

create trigger trg_LogFlightTimeChanges
on Flights
after update
as
begin
    if update(DepartureTime) or update(ArrivalTime)
    begin
        insert into FlightTimeChangesLog (FlightID, OldDepartureTime, NewDepartureTime, OldArrivalTime, NewArrivalTime, ChangeDate)
        select d.FlightID, d.DepartureTime, i.DepartureTime, d.ArrivalTime, i.ArrivalTime, getdate()
        from inserted i
        join deleted d on i.FlightID = d.FlightID;
    end
end;
go

create trigger trg_AssignSeatNumber
on Tickets
after insert
as
begin
    declare @flightID int;
    declare @seatNumber int;

    select @flightID = FlightID from inserted;
    select @seatNumber = isnull(max(SeatNumber), 0) + 1 from Tickets where FlightID = @flightID;

    update Tickets
    set SeatNumber = @seatNumber
    where TicketID in (select TicketID from inserted);
end;
go

insert into Flights (FlightNumber, DepartureCity, ArrivalCity, DepartureTime, ArrivalTime)
values
('FL001', 'New York', 'Los Angeles', '2025-12-01 08:00:00', '2025-12-01 11:00:00'),
('FL002', 'Chicago', 'Miami', '2025-12-01 09:00:00', '2025-12-01 13:00:00'),
('FL003', 'Dallas', 'San Francisco', '2025-12-02 10:00:00', '2025-12-02 12:30:00'),
('FL004', 'Seattle', 'Denver', '2025-12-03 11:00:00', '2025-12-03 14:00:00'),
('FL005', 'Boston', 'Houston', '2025-12-04 12:00:00', '2025-12-04 15:00:00'),
('FL006', 'Atlanta', 'Orlando', '2025-12-05 07:30:00', '2025-12-05 09:00:00'),
('FL007', 'Las Vegas', 'Phoenix', '2025-12-06 13:00:00', '2025-12-06 14:00:00'),
('FL008', 'Detroit', 'Toronto', '2025-12-07 15:00:00', '2025-12-07 17:00:00'),
('FL009', 'San Diego', 'Seattle', '2025-12-08 16:00:00', '2025-12-08 19:00:00'),
('FL010', 'Denver', 'Chicago', '2025-12-09 18:00:00', '2025-12-09 21:00:00');
go
insert into Passengers (FirstName, LastName, PassportNumber)
values
('John', 'Doe', 'A12345678'),
('Jane', 'Smith', 'B23456789'),
('Emily', 'Johnson', 'C34567890'),
('Michael', 'Brown', 'D45678901'),
('Sarah', 'Davis', 'E56789012'),
('David', 'Wilson', 'F67890123'),
('Laura', 'Martinez', 'G78901234'),
('James', 'Anderson', 'H89012345'),
('Robert', 'Taylor', 'I90123456'),
('Olivia', 'Thomas', 'J01234567');
go
insert into Tickets (FlightID, PassengerID, Class, Price, PurchaseDate, SeatNumber)
values
(1, 1, 'Economy', 200.00, '2025-11-25 10:00:00', 1),
(2, 2, 'Business', 500.00, '2025-11-26 11:00:00', 2),
(3, 3, 'Economy', 150.00, '2025-11-27 12:00:00', 3),
(4, 4, 'Business', 450.00, '2025-11-28 13:00:00', 4),
(5, 5, 'Economy', 300.00, '2025-11-29 14:00:00', 5),
(6, 6, 'Business', 550.00, '2025-11-30 15:00:00', 6),
(7, 7, 'Economy', 180.00, '2025-12-01 16:00:00', 7),
(8, 8, 'Business', 600.00, '2025-12-02 17:00:00', 8),
(9, 9, 'Economy', 220.00, '2025-12-03 18:00:00', 9),
(10, 10, 'Business', 700.00, '2025-12-04 19:00:00', 10);
go
-- 1. Всі рейси до певного міста на певну дату
select * from Flights where ArrivalCity = 'Los Angeles' and cast(DepartureTime as date) = '2025-12-01' order by DepartureTime;
go
-- 2. Рейс із найбільшою тривалістю польоту
select top 1 * from Flights order by Duration desc;
go
-- 3. Всі рейси, тривалість яких перевищує 2 години
select * from Flights where Duration > 120;
go
-- 4. Кількість рейсів у кожне місто
select ArrivalCity, count(*) as FlightCount from Flights group by ArrivalCity;
go
-- 5. Місто, в яке найчастіше здійснюються польоти
select top 1 ArrivalCity from Flights group by ArrivalCity order by count(*) desc;
go
-- 6. Кількість рейсів у кожне місто та загальна кількість рейсів за певний місяць
select ArrivalCity, count(*) as FlightCount from Flights where month(DepartureTime) = 12 and year(DepartureTime) = 2023 group by ArrivalCity;
select count(*) as TotalFlights from Flights where month(DepartureTime) = 12 and year(DepartureTime) = 2023;
go
-- 7. Список рейсів, що вилітають сьогодні, з вільними місцями у бізнес-класі
select f.* from Flights f join Tickets t on f.FlightID = t.FlightID where cast(f.DepartureTime as date) = cast(getdate() as date) and t.Class = 'Business' and t.SeatNumber is null;
go
-- 8. Кількість проданих квитків і загальна сума за вказаний день
select f.FlightNumber, count(t.TicketID) as TicketsSold, sum(t.Price) as TotalAmount from Flights f join Tickets t on f.FlightID = t.FlightID where cast(t.PurchaseDate as date) = '2023-11-25' group by f.FlightNumber;
go
-- 9. Продаж квитків на певну дату з кількістю проданих квитків
select f.FlightNumber, count(t.TicketID) as TicketsSold from Flights f join Tickets t on f.FlightID = t.FlightID where cast(t.PurchaseDate as date) = '2023-11-25' group by f.FlightNumber;
go
-- 10. Номери всіх рейсів та міста призначення
select FlightNumber, ArrivalCity from Flights;
go

