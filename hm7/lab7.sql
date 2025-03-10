create database Hospital;
go
use Hospital;
go
create table Departments(
    DepartmentID int primary key not null identity (1,1),
    DepartmentBuilding int not null check (DepartmentBuilding between 1 and 5) ,
    DepartmentFinancing money not null check (DepartmentFinancing > 0) default 0,
    DepartmentName nvarchar(100) not null check (DepartmentName <> '') unique
);
go
create table Diseases
(
    DiseaseID   int primary key not null identity (1,1),
    DiseaseName nvarchar(100)   not null check (DiseaseName <> '') unique,
);
go
create table Doctors(
    DoctorID int not null primary key identity (1,1),
    DoctorName nvarchar(max) not null check (DoctorName <> ''),
    DoctorSalary money not null check (DoctorSalary > 0),
    DoctorSurname nvarchar(max) not null check (DoctorSurname <> ''),
);
go
create table DoctorsExaminations(
    DoctorExaminationID int primary key not null identity (1,1),
    Date date not null default getdate(),
    DiseaseID int not null foreign key references Diseases(DiseaseID),
    DoctorID int not null foreign key references Doctors(DoctorID),
    ExaminationID int not null foreign key references Examinations(ExaminationID),
    WardID int not null foreign key references Wards(WardID)
);
go
create table Examinations(
    ExaminationID int primary key not null identity (1,1),
    ExaminationName nvarchar(100) not null check (ExaminationName <> '') unique,
);
go
create table Inters(
    InterID int primary key not null identity (1,1),
    DoctorID int not null foreign key references Doctors(DoctorID),
);
go
create table Professors(
    ProfessorID int not null primary key identity (1,1),
    DoctorID int not null foreign key references Doctors(DoctorID),
);
go
create table Wards(
    WardID int  primary key not null  identity (1,1),
    WardName nvarchar(20) not null check (WardName <> '') unique,
    WardPLaces int not null check (WardPLaces >= 1),
    DepartmentID int not null foreign key references Departments(DepartmentID)
);
go
insert into Departments(DepartmentBuilding, DepartmentFinancing, DepartmentName) values
(1, 1000000, 'Surgery'),
(2, 2000000, 'Therapy'),
(3, 3000000, 'Ophtalmology'),
(4, 4000000, 'Physiotherapy'),
(5, 5000000, 'Oncology');
go
insert into Diseases(DiseaseName) values
('Flu'),
('Cancer'),
('Diabetes'),
('Hypertension'),
('AIDS');
go
insert into Doctors(DoctorName, DoctorSalary, DoctorSurname) values
('John', 1000, 'Smith'),
('Jane', 2000, 'Johnson'),
('Jack', 3000, 'Williams'),
('Jill', 4000, 'Brown'),
('Jim', 5000, 'Jones');
go
insert into Examinations(ExaminationName) values
('Blood test'),
('MRI'),
('X-ray'),
('Ultrasound'),
('CT');
go
insert into Wards(WardName, WardPLaces, DepartmentID) values
('Surgery1', 10, 1),
('Surgery2', 20, 1),
('Therapy1', 30, 2),
('Therapy2', 40, 2),
('Ophtalmology1', 50, 3),
('Ophtalmology2', 60, 3),
('Physiotherapy1', 70, 4),
('Physiotherapy2', 80, 4),
('Oncology1', 90, 5),
('Oncology2', 100, 5);
go
insert into DoctorsExaminations(Date, DiseaseID, DoctorID, ExaminationID, WardID) values
('2025-01-01', 1, 1, 1, 1),
('2025-01-02', 2, 2, 2, 2),
('2025-01-03', 3, 3, 3, 3),
('2025-01-04', 4, 4, 4, 4),
('2025-01-05', 5, 5, 5, 5);
go
insert into Inters(DoctorID) values
(1),
(2),
(3),
(4),
(5);
go
insert into Professors(DoctorID) values
(1),
(2),
(3),
(4),
(5);
go
select WardName, WardPLaces
from Wards
where DepartmentID in (
    select DepartmentID
    from Departments
    where DepartmentBuilding = 5
)
and WardPLaces >= 5
and exists (
    select 1
    from Wards w
    join Departments d on w.DepartmentID = d.DepartmentID
    where d.DepartmentBuilding = 5
    and w.WardPLaces > 15
);
go
select distinct d.DepartmentName
from Departments d
join Wards w on d.DepartmentID = w.DepartmentID
join DoctorsExaminations de on w.WardID = de.WardID
where de.Date >= dateadd(week, -1, getdate());
go
select DiseaseName
from Diseases
where DiseaseID not in (
    select distinct DiseaseID
    from DoctorsExaminations
);
go
select DoctorName + ' ' + DoctorSurname as FullName
from Doctors
where DoctorID not in (
    select distinct DoctorID
    from DoctorsExaminations
);
go
select DepartmentName
from Departments
where DepartmentID not in (
    select distinct d.DepartmentID
    from Departments d
    join Wards w on d.DepartmentID = w.DepartmentID
    join DoctorsExaminations de on w.WardID = de.WardID
);
go
select DoctorSurname
from Doctors
where DoctorID in (
    select DoctorID
    from Inters
);
go
select d.DoctorSurname
from Doctors d
join Inters i on d.DoctorID = i.DoctorID
where d.DoctorSalary > any (
    select DoctorSalary
    from Doctors
);
go
select WardName
from Wards
where WardPLaces > all (
    select WardPLaces
    from Wards w
    join Departments d on w.DepartmentID = d.DepartmentID
    where d.DepartmentBuilding = 3
);
go
select distinct d.DoctorSurname
from Doctors d
join DoctorsExaminations de on d.DoctorID = de.DoctorID
join Wards w on de.WardID = w.WardID
join Departments dep on w.DepartmentID = dep.DepartmentID
where dep.DepartmentName in ('Ophthalmology', 'Physiotherapy');
go
select distinct dep.DepartmentName
from Departments dep
join Wards w on dep.DepartmentID = w.DepartmentID
join DoctorsExaminations de on w.WardID = de.WardID
join Doctors d on de.DoctorID = d.DoctorID
where d.DoctorID in (
    select DoctorID
    from Inters
)
and d.DoctorID in (
    select DoctorID
    from Professors
);
go
select d.DoctorName + ' ' + d.DoctorSurname as FullName, dep.DepartmentName
from Doctors d
join DoctorsExaminations de on d.DoctorID = de.DoctorID
join Wards w on de.WardID = w.WardID
join Departments dep on w.DepartmentID = dep.DepartmentID
where dep.DepartmentFinancing > 20000;
go
select dep.DepartmentName
from Departments dep
join Wards w on dep.DepartmentID = w.DepartmentID
join DoctorsExaminations de on w.WardID = de.WardID
join Doctors d on de.DoctorID = d.DoctorID
where d.DoctorSalary = (
    select max(DoctorSalary)
    from Doctors
);