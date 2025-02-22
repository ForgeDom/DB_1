create database Academy;
go
use Academy;
go
create table Faculties (
    Id int primary key not null identity(1,1),
    Name nvarchar(100) not null check (Name <> '') unique
);
go

create table Departments (
    Id int primary key not null identity(1,1),
    Financing money not null check (Financing >= 0) default 0,
    Name nvarchar(100) not null check (Name <> '') unique,
    FacultyId int not null,
    foreign key (FacultyId) references Faculties(Id)
);
go

create table Groups (
    Id int primary key not null identity(1,1),
    Name nvarchar(10) not null check (Name <> '') unique,
    Year int not null check (Year between 1 and 5),
    DepartmentId int not null,
    foreign key (DepartmentId) references Departments(Id)
);
go
create table Lectures (
    Id int primary key not null identity(1,1),
    DayOfWeek int not null check (DayOfWeek between 1 and 7),
    LectureRoom nvarchar(max) not null,
    SubjectId int not null,
    TeacherId int not null,
    foreign key (SubjectId) references Subjects(Id),
    foreign key (TeacherId) references Teachers(Id)
);
go

create table GroupsLectures (
    Id int primary key not null identity(1,1),
    GroupId int not null,
    LectureId int not null,
    foreign key (GroupId) references Groups(Id),
    foreign key (LectureId) references Lectures(Id)
);
go

create table Students (
    Id int primary key not null identity(1,1),
    Name nvarchar(max) not null check (Name <> ''),
    Rating int not null check (Rating between 0 and 5),
    Surname nvarchar(max) not null check (Surname <> '')
);
go

create table GroupsStudents (
    Id int primary key not null identity(1,1),
    GroupId int not null,
    StudentId int not null,
    foreign key (GroupId) references Groups(Id),
    foreign key (StudentId) references Students(Id)
);
go

create table Subjects (
    Id int primary key not null identity(1,1),
    Name nvarchar(100) not null check (Name <> '') unique
);
go

create table Teachers (
    Id int primary key not null identity(1,1),
    Name nvarchar(max) not null check (Name <> ''),
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null check (Surname <> '')
);
go
insert into Faculties (Name) values
('Computer Science'),
('Mathematics'),
('Physics'),
('Chemistry'),
('Biology');
go
insert into Departments (Financing, Name, FacultyId) values
(100000, 'Software Development', 1),
(200000, 'Data Science', 1),
(300000, 'Computer Engineering', 1),
(400000, 'Mathematics', 2),
(500000, 'Physics', 3),
(600000, 'Chemistry', 4),
(700000, 'Biology', 5);
go
insert into Groups (Name, Year, DepartmentId) values
('SD-1', 1, 1),
('SD-2', 2, 1),
('SD-3', 3, 1),
('SD-4', 4, 1),
('SD-5', 5, 1),
('DS-1', 1, 2),
('DS-2', 2, 2),
('DS-3', 3, 2),
('DS-4', 4, 2),
('DS-5', 5, 2),
('CE-1', 1, 3),
('CE-2', 2, 3),
('CE-3', 3, 3),
('CE-4', 4, 3),
('CE-5', 5, 3),
('M-1', 1, 4),
('M-2', 2, 4),
('M-3', 3, 4),
('M-4', 4, 4),
('M-5', 5, 4),
('P-1', 1, 5),
('P-2', 2, 5),
('P-3', 3, 5),
('P-4', 4, 5),
('P-5', 5, 5),
('C-1', 1, 6),
('C-2', 2, 6),
('C-3', 3, 6),
('C-4', 4, 6),
('C-5', 5, 6),
('B-1', 1, 7),
('B-2', 2, 7),
('B-3', 3, 7),
('B-4', 4, 7),
('B-5', 5, 7);
go
insert into Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) values
(1, 'D101', 1, 1),
(2, 'D102', 2, 2),
(3, 'D103', 3, 3),
(4, 'D104', 4, 4),
(5, 'D105', 5, 5),
(6, 'D106', 6, 6),
(7, 'D107', 7, 7),
(1, 'D201', 8, 8),
(2, 'D202', 9, 9),
(3, 'D203', 10, 10),
(4, 'D204', 11, 11),
(5, 'D205', 12, 12),
(6, 'D206', 13, 13),
(7, 'D207', 14, 14),
(1, 'D301', 15, 15),
(2, 'D302', 16, 16),
(3, 'D303', 17, 17),
(4, 'D304', 18, 18),
(5, 'D305', 19, 19),
(6, 'D306', 20, 20),
(7, 'D307', 21, 21),
(1, 'D401', 22, 22),
(2, 'D402', 23, 23),
(3, 'D403', 24, 24),
(4, 'D404', 25, 25),
(5, 'D405', 26, 26),
(6, 'D406', 27, 27),
(7, 'D407', 28, 28),
(1, 'D501', 29, 29),
(2, 'D502', 30, 30),
(3, 'D503', 31, 31),
(4, 'D504', 32, 32),
(5, 'D505', 33, 33),
(6, 'D506', 34, 34),
(7, 'D507', 35, 35);
go
insert into GroupsLectures (GroupId, LectureId) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(21, 21),
(22, 22),
(23, 23),
(24, 24),
(25, 25),
(26, 26),
(27, 27),
(28, 28),
(29, 29),
(30, 30),
(31, 31),
(32, 32),
(33, 33),
(34, 34),
(35, 35);
go
insert into Subjects (Name) values
('Mathematics'),
('Physics'),
('Chemistry'),
('Biology'),
('Computer Science'),
('Data Science'),
('Computer Engineering'),
('Algebra'),
('Geometry'),
('Trigonometry'),
('Calculus'),
('Mechanics'),
('Thermodynamics'),
('Electromagnetism'),
('Quantum Mechanics'),
('Organic Chemistry'),
('Inorganic Chemistry'),
('Physical Chemistry'),
('Biochemistry'),
('Genetics'),
('Ecology'),
('Botany'),
('Zoology'),
('Computer Architecture'),
('Operating Systems'),
('Databases'),
('Data Mining'),
('Machine Learning'),
('Artificial Intelligence'),
('Computer Networks'),
('Cryptography');
go
insert into Teachers (Name, Salary, Surname) values
('Alice', 1000, 'Smith'),
('Bob', 2000, 'Smith'),
('Charlie', 3000, 'Smith'),
('David', 4000, 'Smith'),
('Eve', 5000, 'Smith'),
('Frank', 6000, 'Smith'),
('Grace', 7000, 'Smith'),
('Helen', 8000, 'Smith'),
('Ivy', 9000, 'Smith'),
('Jack', 10000, 'Smith'),
('Kate', 11000, 'Smith'),
('Liam', 12000, 'Smith'),
('Mia', 13000, 'Smith'),
('Noah', 14000, 'Smith'),
('Olivia', 15000, 'Smith'),
('Peter', 16000, 'Smith'),
('Quinn', 17000, 'Smith'),
('Rose', 18000, 'Smith'),
('Sophia', 19000, 'Smith'),
('Thomas', 20000, 'Smith'),
('Ursula', 21000, 'Smith'),
('Victor', 22000, 'Smith'),
('Wendy', 23000, 'Smith'),
('Xander', 24000, 'Smith'),
('Yvonne', 25000, 'Smith'),
('Zachary', 26000, 'Smith'),
('Aaron', 27000, 'Smith'),
('Bella', 28000, 'Smith');
go
select count(distinct t.Id) as TeacherCount
from Teachers t
join Subjects s on t.Id = s.Id
join Departments d on s.Id = d.Id
where d.Name = 'Software Development';
go
select count(*) as LectureCount
from Lectures l
join Teachers t on l.TeacherId = t.Id
where t.Name = 'Dave' and t.Surname = 'McQueen';
go
select count(*) as ClassCount
from Lectures
where LectureRoom = 'D201';
go
select LectureRoom, count(*) as LectureCount
from Lectures
group by LectureRoom;
go
select count(distinct gs.StudentId) as StudentCount
from Lectures l
join Teachers t on l.TeacherId = t.Id
join GroupsLectures gl on l.Id = gl.LectureId
join GroupsStudents gs on gl.GroupId = gs.GroupId
where t.Name = 'Jack' and t.Surname = 'Smith';
go
select avg(t.Salary) as AverageSalary
from Teachers t
join Departments d on t.Id = d.Id
join Faculties f on d.FacultyId = f.Id
where f.Name = 'Computer Science';
go
select min(StudentCount) as MinStudentCount, max(StudentCount) as MaxStudentCount
from (
    select count(gs.StudentId) as StudentCount
    from Groups g
    join GroupsStudents gs on g.Id = gs.GroupId
    group by g.Id
) as GroupStudentCounts;
go
select avg(Financing) as AverageFinancing
from Departments;
go
select t.Name + ' ' + t.Surname as FullName, count(distinct l.SubjectId) as SubjectCount
from Teachers t
join Lectures l on t.Id = l.TeacherId
group by t.Name, t.Surname;
go
select DayOfWeek, count(*) as LectureCount
from Lectures
group by DayOfWeek;
go
select LectureRoom, count(distinct d.Id) as DepartmentCount
from Lectures l
join Subjects s on l.SubjectId = s.Id
join Departments d on s.Id = d.Id
group by LectureRoom;
go
select f.Name as FacultyName, count(distinct s.Id) as SubjectCount
from Faculties f
join Departments d on f.Id = d.FacultyId
join Subjects s on d.Id = s.Id
group by f.Name;
go
select t.Name + ' ' + t.Surname as TeacherFullName, l.LectureRoom, count(*) as LectureCount
from Lectures l
join Teachers t on l.TeacherId = t.Id
group by t.Name, t.Surname, l.LectureRoom;