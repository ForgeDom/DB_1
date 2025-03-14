create database SportsStore;
go
use SportsStore;
go
create table Products (
    ProductID int primary key not null identity (1,1),
    ProductName nvarchar(50) not null,
    ProductType nvarchar(50) not null,
    QuantityInStock int not null check (QuantityInStock >= 0),
    CostPrice money not null check (CostPrice > 0),
    Manufacturer nvarchar(50) not null,
    SalePrice money not null check (SalePrice > 0)
);
go
create table Employees (
    EmployeeID int primary key not null identity (1,1),
    FullName nvarchar(100) not null,
    Position nvarchar(50) not null,
    HireDate date not null,
    Gender nvarchar(10) not null,
    Salary money not null check (Salary > 0)
);
go
create table Customers (
    CustomerID int primary key not null identity (1,1),
    FullName nvarchar(100) not null,
    Email nvarchar(100) not null,
    ContactPhone nvarchar(20) not null,
    Gender nvarchar(10) not null,
    OrderHistory nvarchar(max),
    DiscountRate float not null check (DiscountRate >= 0 and DiscountRate <= 100),
    IsSubscribedToNewsletter bit not null
);

create table Sales (
    SaleID int primary key not null identity (1,1),
    ProductID int not null,
    SalePrice money not null check (SalePrice > 0),
    Quantity int not null check (Quantity > 0),
    SaleDate date not null,
    EmployeeID int not null,
    CustomerID int,
    foreign key (ProductID) references Products(ProductID),
    foreign key (EmployeeID) references Employees(EmployeeID),
    foreign key (CustomerID) references Customers(CustomerID)
);
go
insert into Products (ProductName, ProductType, QuantityInStock, CostPrice, Manufacturer, SalePrice) values
('Football', 'Sports', 100, 10, 'Nike', 20),
('Basketball', 'Sports', 50, 15, 'Adidas', 25),
('Volleyball', 'Sports', 30, 20, 'Mikasa', 30),
('Tennis Racket', 'Sports', 40, 30, 'Wilson', 50),
('Tennis Ball', 'Sports', 200, 1, 'Wilson', 2),
('Soccer Ball', 'Sports', 100, 5, 'Nike', 10),
('Baseball Bat', 'Sports', 50, 10, 'Rawlings', 20),
('Baseball Ball', 'Sports', 100, 2, 'Rawlings', 5);
go
insert into Employees (FullName, Position, HireDate, Gender, Salary) values
('John Smith', 'Sales Manager', '2020-01-15', 'Male', 5000),
('Jane Doe', 'Cashier', '2019-03-22', 'Female', 3000),
('Michael Brown', 'Stock Manager', '2018-07-30', 'Male', 4000),
('Emily Davis', 'Sales Associate', '2021-05-10', 'Female', 3500),
('David Wilson', 'Assistant Manager', '2017-11-05', 'Male', 4500);
go
insert into Customers (FullName, Email, ContactPhone, Gender, OrderHistory, DiscountRate, IsSubscribedToNewsletter) values
('Alice Johnson', 'alice.johnson@example.com', '123-456-7890', 'Female', 'Football, Basketball', 10, 1),
('Bob Smith', 'bob.smith@example.com', '234-567-8901', 'Male', 'Tennis Racket, Tennis Ball', 15, 0),
('Charlie Brown', 'charlie.brown@example.com', '345-678-9012', 'Male', 'Volleyball', 5, 1),
('Diana Prince', 'diana.prince@example.com', '456-789-0123', 'Female', 'Soccer Ball', 20, 1),
('Eve Adams', 'eve.adams@example.com', '567-890-1234', 'Female', 'Baseball Bat, Baseball Ball', 25, 0);
go
insert into Sales (ProductID, SalePrice, Quantity, SaleDate, EmployeeID, CustomerID) values
(1, 20, 2, '2023-01-01', 1, 1),
(2, 25, 1, '2023-01-02', 2, 2),
(3, 30, 3, '2023-01-03', 3, 3),
(4, 50, 1, '2023-01-04', 4, 4),
(5, 2, 10, '2023-01-05', 5, 5);
go
create table History (
    SaleID int,
    ProductID int,
    SalePrice money,
    Quantity int,
    SaleDate date,
    EmployeeID int,
    CustomerID int
);
go

create trigger trg_InsertHistory on Sales
after insert
as
begin
    insert into History (SaleID, ProductID, SalePrice, Quantity, SaleDate, EmployeeID, CustomerID)
    select SaleID, ProductID, SalePrice, Quantity, SaleDate, EmployeeID, CustomerID
    from inserted;
end;
go

create table Archive (
    ProductID int,
    ProductName nvarchar(50),
    ProductType nvarchar(50),
    QuantityInStock int,
    CostPrice money,
    Manufacturer nvarchar(50),
    SalePrice money
);
go

create trigger trg_MoveToArchive on Sales
after insert
as
begin
    if exists (select 1 from Products p join inserted i on p.ProductID = i.ProductID where p.QuantityInStock = 0)
    begin
        insert into Archive (ProductID, ProductName, ProductType, QuantityInStock, CostPrice, Manufacturer, SalePrice)
        select p.ProductID, p.ProductName, p.ProductType, p.QuantityInStock, p.CostPrice, p.Manufacturer, p.SalePrice
        from Products p join inserted i on p.ProductID = i.ProductID
        where p.QuantityInStock = 0;

        delete from Products where ProductID in (select ProductID from inserted);
    end
end;
go

create trigger trg_PreventDuplicateCustomer on Customers
instead of insert
as
begin
    if exists (select 1 from Customers where FullName = (select FullName from inserted) and Email = (select Email from inserted))
    begin
        raiserror('Customer already exists', 16, 1);
    end
    else
    begin
        insert into Customers (FullName, Email, ContactPhone, Gender, OrderHistory, DiscountRate, IsSubscribedToNewsletter)
        select FullName, Email, ContactPhone, Gender, OrderHistory, DiscountRate, IsSubscribedToNewsletter
        from inserted;
    end
end;
go

create trigger trg_PreventCustomerDeletion on Customers
instead of delete
as
begin
    raiserror('Deleting customers is not allowed', 16, 1);
end;
go

create trigger trg_PreventEmployeeDeletion on Employees
instead of delete
as
begin
    if exists (select 1 from Employees e join deleted d on e.EmployeeID = d.EmployeeID where e.HireDate < '2015-01-01')
    begin
        raiserror('Deleting employees hired before 2015 is not allowed', 16, 1);
    end
    else
    begin
        delete from Employees where EmployeeID in (select EmployeeID from deleted);
    end
end;
go

create trigger trg_SetDiscountRate on Sales
after insert
as
begin
    update Customers
    set DiscountRate = 15
    where CustomerID in (select CustomerID from inserted)
    and (select sum(SalePrice * Quantity) from Sales where CustomerID = (select CustomerID from inserted)) > 50000;
end;
go

create trigger trg_PreventSpecificManufacturer on Products
instead of insert
as
begin
    if exists (select 1 from inserted where Manufacturer = 'Спорт, сонце та штанга')
    begin
        raiserror('Adding products from Спорт, сонце та штанга is not allowed', 16, 1);
    end
    else
    begin
        insert into Products (ProductName, ProductType, QuantityInStock, CostPrice, Manufacturer, SalePrice)
        select ProductName, ProductType, QuantityInStock, CostPrice, Manufacturer, SalePrice
        from inserted;
    end
end;
go

create table LastUnit (
    ProductID int,
    ProductName nvarchar(50),
    ProductType nvarchar(50),
    QuantityInStock int,
    CostPrice money,
    Manufacturer nvarchar(50),
    SalePrice money
);
go

create trigger trg_InsertLastUnit on Sales
after insert
as
begin
    if exists (select 1 from Products p join inserted i on p.ProductID = i.ProductID where p.QuantityInStock = 1)
    begin
        insert into LastUnit (ProductID, ProductName, ProductType, QuantityInStock, CostPrice, Manufacturer, SalePrice)
        select p.ProductID, p.ProductName, p.ProductType, p.QuantityInStock, p.CostPrice, p.Manufacturer, p.SalePrice
        from Products p join inserted i on p.ProductID = i.ProductID
        where p.QuantityInStock = 1;
    end
end;
go
-----------------------------------------------------------


create trigger trg_CheckAndUpdateProduct on Products
instead of insert
as
begin
    if exists (select 1 from Products where ProductName = (select ProductName from inserted) and ProductType = (select ProductType from inserted) and Manufacturer = (select Manufacturer from inserted))
    begin
        update Products
        set QuantityInStock = QuantityInStock + (select QuantityInStock from inserted)
        where ProductName = (select ProductName from inserted) and ProductType = (select ProductType from inserted) and Manufacturer = (select Manufacturer from inserted);
    end
    else
    begin
        insert into Products (ProductName, ProductType, QuantityInStock, CostPrice, Manufacturer, SalePrice)
        select ProductName, ProductType, QuantityInStock, CostPrice, Manufacturer, SalePrice
        from inserted;
    end
end;
go

create table EmployeeArchive (
    EmployeeID int,
    FullName nvarchar(100),
    Position nvarchar(50),
    HireDate date,
    Gender nvarchar(10),
    Salary money,
    TerminationDate date
);
go

create trigger trg_MoveToEmployeeArchive on Employees
instead of delete
as
begin
    insert into EmployeeArchive (EmployeeID, FullName, Position, HireDate, Gender, Salary, TerminationDate)
    select EmployeeID, FullName, Position, HireDate, Gender, Salary, getdate()
    from deleted;

    delete from Employees where EmployeeID in (select EmployeeID from deleted);
end;
go

create trigger trg_LimitSalespersons on Employees
instead of insert
as
begin
    if (select count(*) from Employees where Position = 'Salesperson') > 6
    begin
        raiserror('Cannot add new salesperson, limit of 6 reached', 16, 1);
    end
    else
    begin
        insert into Employees (FullName, Position, HireDate, Gender, Salary)
        select FullName, Position, HireDate, Gender, Salary
        from inserted;
    end
end;
go