create database Hospital;
go
use Hospital;
create table Departments(
    DepartmentID int not null primary key identity (1,1),
    DepartmentName nvarchar(100) not null check (DepartmentName <> '') unique
)
go
create table Doctors(
    DoctorID int not null primary key identity (1,1),
    DoctorsName nvarchar(max) not null check (DoctorsName <> ''),
    DoctorsPremium money not null check (DoctorsPremium >= 0) default 0,
    DoctorsSalary money not null check (DoctorsSalary > 0),
    DoctorsSurname nvarchar(max) not null check (DoctorsSurname <> '')
)
go
create table DoctorsSpecializations(
    DoctorsSpecializationID int not null primary key identity (1,1),
    DoctorID int not null,
    DoctorSpecializationID int not null,
    foreign key (DoctorID) references Departments(DepartmentID),
    foreign key (DoctorSpecializationID) references Doctors(DoctorID)
)
go
create table Donations(
    DonationsID int not null  primary key identity (1,1),
    DonationAmount money not null check (DonationAmount > 0),
    DonationDate date not null default getdate(),
    DepartmentID int not null,
    SponsorID int not null ,
    foreign key (DepartmentID) references Departments(DepartmentID),
    foreign key (SponsorID) references Sponsors(SponsorID),
    check (DonationDate < getdate())
)
go
create table Specializations(
    SpecializationID int not null primary key identity (1,1),
    SpecializationName nvarchar(100) not null check (SpecializationName <> '') unique
)
go
create table Sponsors(
    SponsorID int not null primary key identity (1,1),
    SponsorName nvarchar(100) not null check (SponsorName <> '') unique
)
go
create table Vacations(
    VacationID int not null primary key identity (1,1),
    EndDate date not null,
    StartDate date not null,
    DoctorID int not null,
    foreign key (DoctorID) references Doctors(DoctorID),
    check (EndDate > StartDate)
)
go
create table Wards(
    WardID int not null primary key identity (1,1),
    WardName nvarchar(20) not null check (WardName <> '') unique,
    DepartmentID int not null,
    foreign key (DepartmentID) references Departments(DepartmentID)
)
go
-- Insert into Departments
insert into Departments (DepartmentName) values
('Cardiology'),
('Neurology'),
('Oncology'),
('Pediatrics'),
('Radiology');

-- Insert into Doctors
insert into Doctors (DoctorsName, DoctorsPremium, DoctorsSalary, DoctorsSurname) values
('John', 500, 5000, 'Doe'),
('Jane', 300, 4500, 'Smith'),
('Emily', 400, 4800, 'Johnson'),
('Michael', 200, 4700, 'Brown'),
('Sarah', 350, 4600, 'Davis');

-- Insert into Specializations
insert into Specializations (SpecializationName) values
('Cardiology'),
('Neurology'),
('Oncology'),
('Pediatrics'),
('Radiology');

-- Insert into DoctorsSpecializations
insert into DoctorsSpecializations (DoctorID, DoctorSpecializationID) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert into Sponsors
insert into Sponsors (SponsorName) values
('Health Foundation'),
('Medical Trust'),
('Wellness Fund'),
('Care Support'),
('Life Aid');

-- Insert into Donations
insert into Donations (DonationAmount, DonationDate, DepartmentID, SponsorID) values
(10000, '2023-01-01', 1, 1),
(15000, '2023-02-01', 2, 2),
(20000, '2023-03-01', 3, 3),
(25000, '2023-04-01', 4, 4),
(30000, '2023-05-01', 5, 5);

-- Insert into Vacations
insert into Vacations (EndDate, StartDate, DoctorID) values
('2023-12-31', '2023-12-01', 1),
('2023-11-30', '2023-11-01', 2),
('2023-10-31', '2023-10-01', 3),
('2023-09-30', '2023-09-01', 4),
('2023-08-31', '2023-08-01', 5);

-- Insert into Wards
insert into Wards (WardName, DepartmentID) values
('Ward A', 1),
('Ward B', 2),
('Ward C', 3),
('Ward D', 4),
('Ward E', 5);
go
select d.DoctorsName + ' ' + d.DoctorsSurname as FullName, s.SpecializationName
from Doctors d
join DoctorsSpecializations ds on d.DoctorID = ds.DoctorID
join Specializations s on ds.DoctorSpecializationID = s.SpecializationID;
go
select d.DoctorsSurname, (d.DoctorsSalary + d.DoctorsPremium) as TotalSalary
from Doctors d
left join Vacations v on d.DoctorID = v.DoctorID
where v.DoctorID is null;
go
select w.WardName
from Wards w
join Departments d on w.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Intensive Treatment';
go
select distinct d.DepartmentName
from Departments d
join Donations dn on d.DepartmentID = dn.DepartmentID
join Sponsors s on dn.SponsorID = s.SponsorID
where s.SponsorName = 'Umbrella Corporation';
go
select d.DepartmentName, s.SponsorName, dn.DonationAmount, dn.DonationDate
from Donations dn
join Departments d on dn.DepartmentID = d.DepartmentID
join Sponsors s on dn.SponsorID = s.SponsorID
where dn.DonationDate >= dateadd(month, -1, getdate());
go
select distinct d.DepartmentName, doc.DoctorsName + ' ' + doc.DoctorsSurname as DoctorName
from Departments d
join Donations dn on d.DepartmentID = dn.DepartmentID
join Doctors doc on d.DepartmentID = doc.DepartmentID
where dn.DonationAmount > 100000;
go
select distinct dep.DepartmentName
from Departments dep
join Doctors doc on dep.DepartmentID = doc.DepartmentID
where doc.DoctorsPremium = 0;
go
