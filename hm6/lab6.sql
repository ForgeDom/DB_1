create database Hospital;
go
use Hospital;
go
create table Departments(
    DepartmentID int primary key not null identity(1,1),
    DepartmentBuilding int not null check (DepartmentBuilding between 1 and 5),
    DepartmentName nvarchar(100) not null check (DepartmentName <> '') unique
);
go
create table Doctors(
    DoctorID int primary key not null identity(1,1),
    DoctorName nvarchar(max) not null check (DoctorName <> ''),
    DoctorPremium money not null check (DoctorPremium >= 0) default 0,
    DoctorSalary money not null check (DoctorSalary > 0),
    DoctorSurname nvarchar(max) not null check (DoctorSurname <> '')
);
go
create table DoctorsExaminations(
    DoctorsExaminationsID int primary key not null identity(1,1),
    EndTime time not null,
    StartTime time not null check (StartTime between '08:00' and '18:00'),
    DoctorId int not null,
    ExaminationId int not null,
    WardId int not null,
    check (EndTime > StartTime),
    foreign key (DoctorId) references Doctors(DoctorID),
    foreign key (ExaminationId) references Examinations(ExaminationID),
    foreign key (WardId) references Wards(WardID)
);
go
create table Donations(
    DonationID int primary key not null identity(1,1),
    Amount money not null check (Amount > 0),
    Date date not null default getdate() check (Date <= getdate()),
    DepartmentId int not null,
    SponsorId int not null,
    foreign key (DepartmentId) references Departments(DepartmentID),
    foreign key (SponsorId) references Sponsors(SponsorID)
);
go
create table Examinations(
    ExaminationID int primary key not null identity(1,1),
    ExaminationName nvarchar(100) not null check (ExaminationName <> '') unique
);
go
create table Sponsors(
    SponsorID int primary key not null identity(1,1),
    SponsorName nvarchar(100) not null check (SponsorName <> '') unique
);
go
create table Wards(
    WardID int primary key not null identity(1,1),
    WardName nvarchar(20) not null check (WardName <> '') unique,
    Places int not null check (Places >= 1),
    DepartmentId int not null,
    foreign key (DepartmentId) references Departments(DepartmentID)
);
go
insert into Departments(DepartmentBuilding, DepartmentName) values
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Oncology'),
(4, 'Pediatrics'),
(5, 'Surgery'),
(1, 'Gastroenterology'),
(5, 'General Surgery');
go
insert into Doctors(DoctorName, DoctorPremium, DoctorSalary, DoctorSurname) values
('John', 1000, 5000, 'Doe'),
('Jane', 2000, 6000, 'Doe'),
('Jack', 3000, 7000, 'Doe'),
('Jill', 4000, 8000, 'Doe');
go
insert into Examinations(ExaminationName) values
('Blood test'),
('MRI'),
('X-ray');
go
insert into Sponsors(SponsorName) values
('John Doe'),
('Jane Doe'),
('Jack Doe'),
('Jill Doe');
go
insert into Wards(WardName, Places, DepartmentId) values
('Cardiology Ward', 10, 1),
('Neurology Ward', 10, 2),
('Oncology Ward', 10, 3),
('Pediatrics Ward', 10, 4),
('Surgery Ward', 10, 5);
go
insert into DoctorsExaminations(EndTime, StartTime, DoctorId, ExaminationId, WardId) values
('10:00', '08:00', 1, 1, 1),
('12:00', '10:00', 2, 2, 2),
('14:00', '12:00', 3, 3, 3),
('16:00', '14:00', 4, 1, 4);
go
insert into Donations(Amount, DepartmentId, SponsorId) values
(3000, 1, 1),
(2000, 2, 2),
(3000, 3, 3),
(4000, 4, 4);
go
select DepartmentName from Departments where DepartmentBuilding = (select DepartmentBuilding from Departments where DepartmentName = 'Cardiology');
go
select DepartmentName from Departments where DepartmentBuilding = (select DepartmentBuilding from Departments where DepartmentName = 'Gastroenterology' and DepartmentName = 'General Surgery');
go
select DepartmentName from Departments where DepartmentID = (select top 1 DepartmentID from Donations group by DepartmentID order by sum(Amount) asc);
go
select DoctorSurname from Doctors where DoctorSalary > (select DoctorSalary from Doctors where DoctorName = 'Thomas' and DoctorSurname = 'Gerada');
go
insert into Doctors(DoctorName, DoctorPremium, DoctorSalary, DoctorSurname)
values ('Thomas', 3000, 6500, 'Gerada');
go
insert into Departments(DepartmentBuilding, DepartmentName) values
(4, 'Microbiology');
go
insert into Wards(WardName, Places, DepartmentId) values
('Microbiology Ward', 10, 6);
go
update Wards set Places = 8 where WardName = 'Microbiology Ward';
go
select WardName from Wards where Places > (select avg(Places) from Wards join Departments on Wards.DepartmentId = Departments.DepartmentID where DepartmentName = '<Microbiology>');
go
select DoctorName + '' + DoctorSurname from Doctors where (DoctorSalary + DoctorPremium) > (select DoctorSalary+DoctorPremium from Doctors where DoctorName = 'Thomas' and DoctorSurname = 'Gerada');
go
select d.DepartmentName
from Departments d
join Wards w on d.DepartmentID = w.DepartmentId
join DoctorsExaminations de on w.WardID = de.WardId
join Doctors doc on de.DoctorId = doc.DoctorID
where doc.DoctorName = 'John' and doc.DoctorSurname = 'Doe';
go
select SponsorName from Sponsors where SponsorID not in (select SponsorID from Donations where DepartmentId in(select DepartmentID from Departments where DepartmentName in ('Neurology','Oncology')));
go
select DoctorSurname from Doctors join DoctorsExaminations DE on Doctors.DoctorID = DE.DoctorId where de.StartTime >= '12:00' and de.EndTime <= '15:00';