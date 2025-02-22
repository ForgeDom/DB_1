create database Hospital_V2;
go
use Hospital_V2;
go
create table Departments(
    DepartmentID int not null primary key identity(1,1),
    DepartmentBuilding int not null check (DepartmentBuilding between 1 and 5),
    DepartmentName nvarchar(100) not null unique check (DepartmentName <> '')
)
go
create table Doctors(
    DoctorID int not null primary key identity(1,1),
    DoctorName nvarchar(max) not null check (DoctorName <> ''),
    DoctorPremium money not null default 0 check (DoctorPremium >= 0),
    DoctorSalary money not null check (DoctorSalary > 0),
    DoctorSurname nvarchar(max) not null check (DoctorSurname <> ''),
    DepartmentID int not null,
    foreign key (DepartmentID) references Departments(DepartmentID)
)
go
create table DoctorsExaminations(
    DoctorsExaminationsID int not null primary key identity(1,1),
    EndTime time not null,
    StartTime time not null check (StartTime between '08:00' and '18:00'),
    DoctorId int not null,
    ExaminationId int not null,
    WardId int not null,
    check (EndTime > StartTime),
    foreign key (DoctorId) references Doctors(DoctorID),
    foreign key (ExaminationId) references Examinations(ExaminationID),
    foreign key (WardId) references Wards(WardID)
)
go
create table Donations(
    DonationID int not null primary key identity(1,1),
    Amount money not null check (Amount > 0),
    Date date not null default getdate() check (Date <= getdate()),
    DepartmentId int not null,
    SponsorId int not null,
    foreign key (DepartmentId) references Departments(DepartmentID),
    foreign key (SponsorId) references Sponsors(SponsorID)
)
go
create table Examinations(
    ExaminationID int not null primary key identity(1,1),
    ExaminationName nvarchar(100) not null unique check (ExaminationName <> '')
)
go
create table Sponsors(
    SponsorID int not null primary key identity(1,1),
    SponsorName nvarchar(100) not null unique check (SponsorName <> '')
)
go
create table Wards(
    WardID int not null primary key identity(1,1),
    WardName nvarchar(20) not null unique check (WardName <> ''),
    Places int not null check (Places >= 1),
    DepartmentId int not null,
    foreign key (DepartmentId) references Departments(DepartmentID)
)
go
insert into Departments(DepartmentBuilding, DepartmentName) values
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Oncology'),
(4, 'Pediatrics'),
(5, 'Surgery');
go
insert into Doctors(DoctorName, DoctorPremium, DoctorSalary, DoctorSurname) values
('John', 1000, 10000, 'Doe'),
('Jane', 2000, 20000, 'Doe'),
('Jack', 3000, 30000, 'Doe'),
('Jill', 4000, 40000, 'Doe'),
('Jim', 5000, 50000, 'Doe');
go
insert into DoctorsExaminations(EndTime, StartTime, DoctorId, ExaminationId, WardId) values
('10:00', '08:00', 1, 1, 1),
('11:00', '09:00', 2, 2, 2),
('12:00', '10:00', 3, 3, 3),
('13:00', '11:00', 4, 4, 4),
('14:00', '12:00', 5, 5, 5);
go
insert into Donations(Amount, DepartmentId, SponsorId) values
(1000, 1, 1),
(2000, 2, 2),
(3000, 3, 3),
(4000, 4, 4),
(5000, 5, 5);
go
insert into Examinations(ExaminationName) values
('Cardiology'),
('Neurology'),
('Oncology'),
('Pediatrics'),
('Surgery');
go
insert into Sponsors(SponsorName) values
('John Doe'),
('Jane Doe'),
('Jack Doe'),
('Jill Doe'),
('Jim Doe');
go
insert into Wards(WardName, Places, DepartmentId) values
('Cardiology Ward', 10, 1),
('Neurology Ward', 10, 2),
('Oncology Ward', 10, 3),
('Pediatrics Ward', 10, 4),
('Surgery Ward', 10, 5);
go
select count(*)
from Wards
where Places > 10;
go
select d.DepartmentBuilding, count(w.WardID) as WardCount
from Departments d
join Wards w on d.DepartmentID = w.DepartmentId
group by d.DepartmentBuilding;
go
select d.DepartmentName, count(w.WardID) as WardCount
from Departments d
join Wards w on d.DepartmentID = w.DepartmentId
group by d.DepartmentName;
go
select d.DepartmentName, sum(doc.DoctorPremium) as TotalPremium
from Departments d
join Doctors doc on d.DepartmentID = doc.DepartmentID
group by d.DepartmentName;
go
select d.DepartmentName
from Departments d
join Doctors doc on d.DepartmentID = doc.DepartmentID
join DoctorsExaminations de on doc.DoctorID = de.DoctorId
group by d.DepartmentName
having count(distinct doc.DoctorID) >= 5;
go
select count(*) as DoctorCount, sum(DoctorSalary + DoctorPremium) as TotalSalary
from Doctors;
go
select avg(DoctorSalary + DoctorPremium) as AverageSalary
from Doctors;
go
select WardName
from Wards
where Places = (select min(Places) from Wards);
go
select d.DepartmentBuilding
from Departments d
join Wards w on d.DepartmentID = w.DepartmentId
where d.DepartmentBuilding in (1, 6, 7, 8)
  and w.Places > 10
group by d.DepartmentBuilding
having sum(w.Places) > 100;
