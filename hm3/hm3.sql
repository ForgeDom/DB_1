create database HospitalDB;
go
use HospitalDB;
go
create table Departments
(
    DepartmentID int primary key identity(1,1) not null,
    DepartmentFinancing money not null check(DepartmentFinancing > 0) default 0,
    DepartmentName varchar(100) not null check(DepartmentName <> '') unique
);
go
create table Faculties
(
    FacultyID int primary key identity(1,1) not null ,
    FacultyDean nvarchar(max) not null check(FacultyDean <> ''),
    FacultyName varchar(100) not null check(FacultyName <> '') unique
);
go
create table Groups
(
    GroupID int primary key identity(1,1) not null,
    GroupName varchar(10) not null check(GroupName <> '') unique,
    GroupRating int not null  check (GroupRating between 0 and 5),
    GroupYear int not null check(GroupYear between 1 and 5)
);
go
create table Teachers(
    TeacherID int primary key identity (1,1) not null,
    TeacherEmploymentDate date not null check (TeacherEmploymentDate >= '01.01.1990'),
    TeacherIsAssistant bit not null default 0,
    TeacherIsProfessor bit not null default 0,
    TeacherName nvarchar(max) not null check(TeacherName <> ''),
    TeacherPosition nvarchar(max) not null check(TeacherPosition <> ''),
    TeacherPremium money not null check(TeacherPremium >= 0) default 0,
    TeacherSalary money not null check(TeacherSalary > 0) default 0,
    TeacherSurname nvarchar(max) not null check(TeacherSurname <> ''),
)
go
insert into Departments(DepartmentFinancing, DepartmentName) values
(100000, 'Mathematics'),
(200000, 'Physics'),
(300000, 'Chemistry'),
(400000, 'Biology'),
(500000, 'Computer Science');
go
insert into Faculties(FacultyDean, FacultyName) values
('John Doe', 'Mathematics'),
('Jane Doe', 'Physics'),
('Jack Doe', 'Chemistry'),
('Jill Doe', 'Biology'),
('Jim Doe', 'Computer Science');
go
insert into Groups(GroupName, GroupRating, GroupYear) values
('A1', 5, 1),
('A2', 4, 2),
('A3', 3, 3),
('A4', 2, 4),
('A5', 1, 5);
go
insert into Teachers(TeacherEmploymentDate, TeacherIsAssistant, TeacherIsProfessor, TeacherName, TeacherPosition, TeacherPremium, TeacherSalary, TeacherSurname) values
('1990-01-01', 1, 0, 'John', 'Assistant', 100, 10000, 'Doe'),
('2001-02-15', 0, 1, 'Jane', 'Professor', 200, 20000, 'Doe'),
('1992-03-20', 1, 0, 'Jack', 'Assistant', 300, 30000, 'Doe'),
('2003-04-25', 0, 1, 'Jill', 'Professor', 4000, 40000, 'Doe'),
('1994-05-30', 1, 0, 'Jim', 'Assistant', 5000, 50000, 'Doe');
go
select DepartmentName, DepartmentFinancing, DepartmentID from Departments;

select GroupName as "Group Name", GroupRating as "Group Rating" from Groups;

select TeacherSurname as 'Teacher Surname',
    (TeacherSalary / TeacherPremium * 100) as 'Salary to Premium Percentage',
    (TeacherSalary / (TeacherSalary + TeacherPremium) * 100) as 'Salary to Total Compensation Percentage'
from Teachers;

select 'The dean of faculty' + Faculties.FacultyName + ' is ' + FacultyDean as 'Dean Information' from Faculties;

select TeacherSurname from Teachers where TeacherIsProfessor = 1 and TeacherSalary > 1050;

select DepartmentName, DepartmentFinancing from Departments where DepartmentFinancing < 11000 or DepartmentFinancing > 25000;

select FacultyName from Faculties where FacultyName not like '%Computer Science%';

select TeacherSurname, TeacherPosition from Teachers where TeacherPosition like '%Assistant%';

select TeacherSurname, TeacherPosition, TeacherSalary, TeacherPremium from Teachers where TeacherPremium between 1600 and 4500;

select TeacherSurname, TeacherSalary from Teachers where TeacherPosition like '%Assistant%';

select TeacherSurname, TeacherPosition from Teachers where TeacherEmploymentDate < '2000-01-01';

select DepartmentName as 'Department Name' from Departments where DepartmentName < 'Sofware Development' order by DepartmentName;

select TeacherSurname from Teachers where TeacherPosition like '%Assistant%' and (TeacherSalary + TeacherPremium) <= 1200;

select GroupName from Groups where GroupYear = 5 and (GroupRating between 2 and 4);

select TeacherSurname from Teachers where TeacherPosition like '%Assistant%' and (TeacherSalary < 500 or TeacherPremium < 200);