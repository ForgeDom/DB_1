create database Academy;
go
use Academy;
go
create table Curators (
    Id int not null primary key identity (1,1),
    Name nvarchar(max) not null check (Name <> ''),
    Surname nvarchar(max) not null check (Surname <> '')
);
go

create table Faculties (
    Id int not null primary key identity (1,1),
    Financing money not null check (Financing >= 0) default 0,
    Name nvarchar(100) not null check (Name <> '') unique
);
go

create table Departments (
    Id int not null primary key identity (1,1),
    Financing money not null check (Financing >= 0) default 0,
    Name nvarchar(100) not null check (Name <> '') unique,
    FacultyId int not null,
    foreign key (FacultyId) references Faculties(Id)
);
go

create table Groups (
    Id int not null primary key identity (1,1),
    Name nvarchar(10) not null check (Name <> '') unique,
    Year int not null check (Year between 1 and 5),
    DepartmentId int not null,
    foreign key (DepartmentId) references Departments(Id)
);
go

create table GroupsCurators (
    Id int not null primary key identity (1,1),
    CuratorId int not null,
    GroupId int not null,
    foreign key (CuratorId) references Curators(Id),
    foreign key (GroupId) references Groups(Id)
);
go

create table GroupsLectures (
    Id int not null primary key identity (1,1),
    GroupId int not null,
    LectureId int not null,
    foreign key (GroupId) references Groups(Id),
    foreign key (LectureId) references Lectures(Id)
);
go

create table Lectures (
    Id int not null primary key identity (1,1),
    LectureRoom nvarchar(max) not null check (LectureRoom <> ''),
    SubjectId int not null,
    TeacherId int not null,
    foreign key (SubjectId) references Subjects(Id),
    foreign key (TeacherId) references Teachers(Id)
);
go

create table Subjects (
    Id int not null primary key identity (1,1),
    Name nvarchar(100) not null check (Name <> '') unique
);
go

create table Teachers (
    Id int not null primary key identity (1,1),
    Name nvarchar(max) not null check (Name <> ''),
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null check (Surname <> '')
);
go
-- Insert into Curators
insert into Curators (Name, Surname) values
('Alice', 'Johnson'),
('Bob', 'Smith'),
('Charlie', 'Brown'),
('Diana', 'Miller'),
('Eve', 'Davis');

-- Insert into Faculties
insert into Faculties (Financing, Name) values
(50000, 'Engineering'),
(60000, 'Arts'),
(70000, 'Science'),
(80000, 'Business'),
(90000, 'Law');

-- Insert into Departments
insert into Departments (Financing, Name, FacultyId) values
(10000, 'Computer Science', 1),
(20000, 'Mechanical Engineering', 1),
(15000, 'Fine Arts', 2),
(25000, 'Physics', 3),
(30000, 'Marketing', 4);

-- Insert into Groups
insert into Groups (Name, Year, DepartmentId) values
('CS101', 1, 1),
('ME201', 2, 2),
('FA301', 3, 3),
('PH401', 4, 4),
('MK501', 5, 5);

-- Insert into GroupsCurators
insert into GroupsCurators (CuratorId, GroupId) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert into GroupsLectures
insert into GroupsLectures (GroupId, LectureId) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Insert into Lectures
insert into Lectures (LectureRoom, SubjectId, TeacherId) values
('Room 101', 1, 1),
('Room 102', 2, 2),
('Room 103', 3, 3),
('Room 104', 4, 4),
('Room 105', 5, 5);

-- Insert into Subjects
insert into Subjects (Name) values
('Mathematics'),
('Physics'),
('Chemistry'),
('Biology'),
('Computer Science');

-- Insert into Teachers
insert into Teachers (Name, Salary, Surname) values
('John', 5000, 'Doe'),
('Jane', 4500, 'Smith'),
('Emily', 4800, 'Johnson'),
('Michael', 4700, 'Brown'),
('Sarah', 4600, 'Davis');
go
select t.Name as TeacherName, t.Surname as TeacherSurname, g.Name as GroupName
from Teachers t
cross join Groups g;
go
select f.Name as FacultyName
from Faculties f
join Departments d on f.Id = d.FacultyId
where d.Financing > f.Financing;
go
select c.Surname as CuratorSurname, g.Name as GroupName
from Curators c
join GroupsCurators gc on c.Id = gc.CuratorId
join Groups g on gc.GroupId = g.Id;
go
select t.Name as TeacherName, t.Surname as TeacherSurname
from Teachers t
join Lectures l on t.Id = l.TeacherId
join GroupsLectures gl on l.Id = gl.LectureId
join Groups g on gl.GroupId = g.Id
where g.Name = 'P107';
go
select t.Surname as TeacherSurname, f.Name as FacultyName
from Teachers t
join Lectures l on t.Id = l.TeacherId
join GroupsLectures gl on l.Id = gl.LectureId
join Groups g on gl.GroupId = g.Id
join Departments d on g.DepartmentId = d.Id
join Faculties f on d.FacultyId = f.Id;
go
select d.Name as DepartmentName, g.Name as GroupName
from Departments d
join Groups g on d.Id = g.DepartmentId;
go
select s.Name as SubjectName
from Subjects s
join Lectures l on s.Id = l.SubjectId
join Teachers t on l.TeacherId = t.Id
where t.Name = 'Samantha' and t.Surname = 'Adams';
go
select distinct d.Name as DepartmentName
from Departments d
join Groups g on d.Id = g.DepartmentId
join GroupsLectures gl on g.Id = gl.GroupId
join Lectures l on gl.LectureId = l.Id
join Subjects s on l.SubjectId = s.Id
where s.Name = 'Database Theory';
go
select g.Name as GroupName
from Groups g
join Departments d on g.DepartmentId = d.Id
join Faculties f on d.FacultyId = f.Id
where f.Name = 'Computer Science';
go
select g.Name as GroupName, f.Name as FacultyName
from Groups g
join Departments d on g.DepartmentId = d.Id
join Faculties f on d.FacultyId = f.Id
where g.Year = 5;
go
select t.Name + ' ' + t.Surname as TeacherFullName, s.Name as SubjectName, g.Name as GroupName
from Teachers t
join Lectures l on t.Id = l.TeacherId
join Subjects s on l.SubjectId = s.Id
join GroupsLectures gl on l.Id = gl.LectureId
join Groups g on gl.GroupId = g.Id
where l.LectureRoom = 'B103';

