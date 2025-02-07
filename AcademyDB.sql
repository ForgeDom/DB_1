create database AcademyDB;
go
use AcademyDB;
go
create table Groups(
   Id int  primary key identity (1,1) not null ,
   Name nvarchar(10) not null CHECK (Name <> '') unique,
   Rating int not null CHECK (Rating between 0 and 5),
    Year int not null CHECK (Year between 1 and 5)
)
go
create table Departments(
    Id int primary key identity (1,1) not null,
    Financing money not null CHECK (Financing > 0) default(0),
    Name nvarchar(100) not null CHECK (Name <> '') unique
)
go
create table Faculties(
    Id int primary key identity (1,1) not null,
    Name nvarchar(100) not null CHECK(Name <> '') unique
)
go
create table Teachers(
    Id int primary key identity (1,1) not null,
    EmploymentDate date not null CHECK (EmploymentDate >= '01.01.1990'),
    Name nvarchar(max) not null CHECK(Name <> ''),
    Premium money not null CHECK (Premium > 0) default (0),
    Salary money not null CHECK (Salary >= 0),
    Surname nvarchar(max) not null CHECK (Surname <> '')

)
go
insert into Departments (Financing, Name)
values
(10000, 'Math'),
(15000, 'Physics'),
(20000, 'Chemistry'),
(25000, 'Biology'),
(30000, 'History');
go
insert into Faculties (Name)
values
('Math'),
('Physics'),
('Chemistry'),
('Biology'),
('History');
go
insert into Teachers (EmploymentDate, Name, Premium, Salary, Surname)
values
('01.01.1994', 'Ivan', 1000, 10000, 'Ivanov'),
('01.01.1997', 'Petro', 2000, 20000, 'Petrov'),
('01.01.2000', 'Stepan', 3000, 30000, 'Stepanov'),
('01.01.1991', 'Vasyl', 4000, 40000, 'Vasyliev'),
('01.01.1992', 'Oleg', 5000, 50000, 'Olegov');
go
select * from Departments;
select * from Faculties;
select * from Teachers;