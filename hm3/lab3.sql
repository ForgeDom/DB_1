create database HospitalDB;
go
use HospitalDB;
go
create table Departments
(
    DepartmentID int primary key identity(1,1),
    DepartmentBuilding int not null check(DepartmentBuilding  like '[0-5]'),
    DepartmentFinancing money not null check(DepartmentFinancing > 0) default 0,
    DepartmentFloor int not null check (DepartmentFloor > 1),
    DepartmentName varchar(100) not null check(DepartmentName <> '') unique
);
create table Diseases
(
    DiseaseID int primary key identity(1,1) not null ,
    DiseaseName varchar(100) not null check(DiseaseName <> '') unique,
    DiseaseSeverity int not null check(DiseaseSeverity > 1) default '1'
);
create table Doctors
(
    DoctorID int primary key not null identity (1,1),
    DoctorName varchar(max) check(DoctorName <> '') not null ,
    DoctorPhone char(10) not null ,
    DoctorPremium money not null check(DoctorPremium > 0) default 0,
    DoctorSalary money not null default 0,
    DoctorSurname nvarchar(max) check(DoctorSurname <> '') not null
);
go
create table Examinations(
    ExaminationID int primary key identity(1,1) not null,
    ExaminationDaysOfWeek int not null check (ExaminationDaysOfWeek between 1 and 7),
    ExaminationStartTime time not null check (ExaminationStartTime between '08:00' and '18:00'),
    ExaminationEndTime time not null,
    ExaminationName nvarchar(100) not null check (ExaminationName <> '') unique,
    ExaminationTimeValid as (case when ExaminationEndTime > ExaminationStartTime then 1 else 0 end) persisted,
    check (ExaminationTimeValid = 1)
);
go
create table Wards
(
    WardID int primary key identity(1,1) not null,
    WardName nvarchar(20) not null check(WardName <> '') unique,
    WardCBuilding int not null check(WardCBuilding between 1 and 5),
    WardFloor int not null check(WardFloor > 1)
);
go
insert into Departments(DepartmentBuilding, DepartmentFinancing, DepartmentFloor, DepartmentName) values
(1, 100000, 2, 'Cardiology'),
(2, 200000, 3, 'Neurology'),
(3, 300000, 4, 'Oncology'),
(4, 400000, 5, 'Surgery'),
(5, 500000, 6, 'Therapy');
go
insert into Diseases(DiseaseName, DiseaseSeverity) values
('Heart attack', 5),
('Stroke', 4),
('Cancer', 3),
('Appendicitis', 2),
('Flu', 2);
go
insert into Doctors(DoctorName, DoctorPhone, DoctorPremium, DoctorSalary, DoctorSurname) values
('John', '1234567890', 1000, 5000, 'Doe'),
('Jane', '0987654321', 2000, 6000, 'Smith'),
('Michael', '1234567890', 3000, 7000, 'Johnson'),
('Jessica', '0987654321', 4000, 8000, 'Brown'),
('William', '1234567890', 5000, 9000, 'Taylor');
go
insert into Examinations(ExaminationDaysOfWeek, ExaminationStartTime, ExaminationEndTime, ExaminationName) values
(1, '08:00', '12:00', 'Blood test'),
(2, '09:00', '13:00', 'MRI'),
(3, '10:00', '14:00', 'X-ray'),
(4, '11:00', '15:00', 'Ultrasound'),
(5, '12:00', '16:00', 'CT'),
(6, '13:00', '17:00', 'ECG'),
(7, '14:00', '18:00', 'EEG');
go
insert into Wards(WardName, WardCBuilding, WardFloor) values
('A1', 1, 2),
('B2', 2, 3),
('C3', 3, 4),
('D4', 4, 6),
('E5', 5, 6);
select * from Wards;
select * from Departments;
select DoctorSurname as 'Doctor Surname', DoctorPhone as 'Doctor Phone' from Doctors;
select distinct WardFloor as 'Ward Floor' from Wards;
select DiseaseName as 'Disease Name', DiseaseSeverity as 'Disease Severity' from Diseases;

select d.DepartmentName as 'Department Name', doc.DoctorName as 'Doctor Name', dis.DiseaseName as 'Disease Name'
from Departments d
join Doctors doc on d.DepartmentID = doc.DoctorID
join Diseases dis on d.DepartmentID = dis.DiseaseID;

select DepartmentName as 'Department Name' from Departments where DepartmentBuilding = 5 and DepartmentFinancing < 300000;

select DepartmentName as 'Department Name' from Departments where DepartmentFloor = 3 and DepartmentFinancing between 12000 and 15000;

select WardName as 'Ward Name' from Wards where WardCBuilding in (4,5) and WardFloor = 1;

select DepartmentName as 'Department Name', DepartmentBuilding as 'Building', DepartmentFinancing as 'Financing'
from Departments
where DepartmentBuilding in (3, 6) and (DepartmentFinancing < 11000 or DepartmentFinancing > 25000);

select DoctorSurname as 'Doctor Surname'
from Doctors
where DoctorSalary + DoctorPremium > 1500;

select DoctorSurname as 'Doctor Surname'
from Doctors
where DoctorSalary / 2 > DoctorPremium * 3;

select distinct ExaminationName as 'Examination Name'
from Examinations
where ExaminationDaysOfWeek in (1, 2, 3) and ExaminationStartTime >= '12:00' and ExaminationEndTime <= '15:00';

select DepartmentName as 'Department Name', DepartmentBuilding as 'Building'
from Departments
where DepartmentBuilding in (1, 3, 8, 10);

select DiseaseName as 'Disease Name'
from Diseases
where DiseaseSeverity not in (1, 2);

select DepartmentName as 'Department Name'
from Departments
where DepartmentBuilding not in (1, 3);

select DepartmentName as 'Department Name'
from Departments
where DepartmentBuilding in (1, 3);

select DoctorSurname as 'Doctor Surname'
from Doctors
where DoctorSurname like 'N%';