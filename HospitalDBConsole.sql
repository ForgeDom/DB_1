create database HospitalDataBase;
go
use HospitalDataBase;
go
create table Departments(
   Id int  primary key identity (1,1) not null ,
   Building int not null CHECK (Building between 1 and 5),
   Financing money not null CHECK (Financing >= 0) default(0),
   Name nvarchar(100) not null CHECK (Name <> '') unique
)
go
create table Diseases(
    Id int primary key identity (1,1) not null,
    Name nvarchar(100) unique CHECK (Name <> ''),
    Severity int not null Check (Severity >= 1) default(1)
)
go
create table Doctors(
    Id int primary key identity (1,1) not null,
    Name nvarchar(max) not null CHECK(Name <> ''),
    Phone char(10) not null,
    Salary money not null CHECK (Salary > 0),
    Surname nvarchar(max) not null CHECK (Surname <> '')
)
go
create table Examinations(
    Id int primary key identity (1,1) not null,
    DaysOfWeek int not null CHECK (DaysOfWeek between 1 and 7),
    StartTime time not null CHECK (StartTime between '8:00' and '18:00'),
    EndTime time not null,
    Name nvarchar(100) not null CHECK (Name <> '') unique,

)
go
create trigger trg_CheckEndTime
on Examinations
for insert, update
as
begin
    if exists(
        select 1 from inserted where EndTime <= StartTime
    )
    begin
        raiserror (N'EndTime повинно бути быльше StartTime!', 16,1);
    end
end
go
insert into Departments (Building, Financing, Name)
values
(1, 10000, 'Cardiology'),
(2, 15000, 'Neurology'),
(3, 20000, 'Oncology'),
(4, 25000, 'Pediatrics'),
(5, 30000, 'Orthopedics');
go
insert into Diseases (Name, Severity)
values
('Flu', 2),
('COVID-19', 5),
('Diabetes', 3),
('Hypertension', 4),
('Asthma', 3);
go
insert into Doctors (Name, Phone, Salary, Surname)
values
('John', '1234567890', 50000, 'Doe'),
('Jane', '0987654321', 60000, 'Smith'),
('Alice', '1122334455', 55000, 'Johnson'),
('Bob', '2233445566', 70000, 'Williams'),
('Charlie', '3344556677', 65000, 'Brown');
go
insert into Examinations (DaysOfWeek, StartTime, EndTime, Name)
values
(1, '09:00', '10:00', 'General Checkup'),
(2, '10:00', '11:00', 'Blood Test'),
(3, '11:00', '12:00', 'MRI Scan'),
(4, '12:00', '13:00', 'X-Ray'),
(5, '13:00', '14:00', 'Ultrasound');
go
select * from Departments;
go
select * from Diseases;
go
select * from Doctors;
go
select * from Examinations;
go