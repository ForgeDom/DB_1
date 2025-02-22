create database Academy_V2;
go
use Academy_V2;
go
create table Departments (
    Id int not null primary key identity(1,1),
    Financing money not null default 0 check (Financing >= 0),
    Name nvarchar(100) not null unique check (Name <> ''),
    FacultyId int not null,
    foreign key (FacultyId) references Faculties(Id)
)
go
create table Faculties (
    Id int not null primary key identity(1,1),
    Name nvarchar(100) not null unique check (Name <> '')
)
go
create table Groups (
    Id int not null primary key identity(1,1),
    Name nvarchar(10) not null unique check (Name <> ''),
    Year int not null check (Year between 1 and 5),
    DepartmentId int not null,
    foreign key (DepartmentId) references Departments(Id)
)
go
create table GroupsLectures (
    Id int not null primary key identity(1,1),
    GroupId int not null,
    LectureId int not null,
    foreign key (GroupId) references Groups(Id),
    foreign key (LectureId) references Lectures(Id)
)
go
create table Lectures (
    Id int not null primary key identity(1,1),
    DayOfWeek int not null check (DayOfWeek between 1 and 7),
    LectureRoom nvarchar(max) not null,
    SubjectId int not null,
    TeacherId int not null,
    foreign key (SubjectId) references Subjects(Id),
    foreign key (TeacherId) references Teachers(Id)
)
go
create table Subjects (
    Id int not null primary key identity(1,1),
    Name nvarchar(100) not null unique check (Name <> '')
)
go
create table Teachers (
    Id int not null primary key identity(1,1),
    Name nvarchar(max) not null check (Name <> ''),
    Salary money not null check (Salary > 0),
    Surname nvarchar(max) not null check (Surname <> '')
)
go
insert into Faculties(Name) values
    ('Computer Science'),
    ('Mathematics'),
    ('Physics');
go
insert into Departments(Financing, Name, FacultyId) values
    (100000, 'Software Development', 1),
    (200000, 'Data Science', 1),
    (300000, 'Algorithms', 2),
    (400000, 'Mathematical Analysis', 2),
    (500000, 'Quantum Mechanics', 3),
    (600000, 'Astrophysics', 3);
go
insert into Groups(Name, Year, DepartmentId) values
    ('SD-1', 1, 1),
    ('SD-2', 2, 1),
    ('DS-1', 1, 2),
    ('DS-2', 2, 2),
    ('AL-1', 1, 3),
    ('AL-2', 2, 3),
    ('MA-1', 1, 4),
    ('MA-2', 2, 4),
    ('QM-1', 1, 5),
    ('QM-2', 2, 5),
    ('AP-1', 1, 6),
    ('AP-2', 2, 6);
go
insert into Subjects(Name) values
    ('Software Development'),
    ('Data Science'),
    ('Algorithms'),
    ('Mathematical Analysis'),
    ('Quantum Mechanics'),
    ('Astrophysics');
go
insert into Teachers(Name, Salary, Surname) values
    ('Dave', 1000, 'McQueen'),
    ('Jack', 2000, 'Underhill'),
    ('Alice', 3000, 'Smith'),
    ('Bob', 4000, 'Johnson'),
    ('Charlie', 5000, 'Williams'),
    ('Daisy', 6000, 'Brown');
go
insert into Lectures(DayOfWeek, LectureRoom, SubjectId, TeacherId) values
    (1, 'D101', 1, 1),
    (2, 'D102', 2, 1),
    (3, 'D103', 3, 2),
    (4, 'D104', 4, 2),
    (5, 'D105', 5, 3),
    (6, 'D201', 6, 3);
go
select count(*)
from Teachers t
join Departments d on t.Id = d.Id
where d.Name = 'Software Development';
go
select count(*)
from Lectures l
join Teachers t on l.TeacherId = t.Id
where t.Name = 'Dave' and t.Surname = 'McQueen';
go
select count(*)
from Lectures
where LectureRoom = 'D201';
go
select LectureRoom, count(*) as LectureCount
from Lectures
group by LectureRoom;
go
select count(distinct gs.Id)
from GroupsLectures gl
join Lectures l on gl.LectureId = l.Id
join Teachers t on l.TeacherId = t.Id
join Groups gs on gl.GroupId = gs.Id
where t.Name = 'Jack' and t.Surname = 'Underhill';
go
select avg(t.Salary)
from Teachers t
join Departments d on t.Id = d.Id
join Faculties f on d.FacultyId = f.Id
where f.Name = 'Computer Science';
go
select min(StudentCount) as MinStudents, max(StudentCount) as MaxStudents
from (
    select count(gs.Id) as StudentCount
    from Groups g
    join Groups gs on g.Id = gs.Id
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
select l.LectureRoom, count(distinct d.Id) as DepartmentCount
from Lectures l
join Subjects s on l.SubjectId = s.Id
join Departments d on s.Id = d.Id
group by l.LectureRoom;
go
select f.Name as FacultyName, count(distinct s.Id) as SubjectCount
from Faculties f
join Departments d on f.Id = d.FacultyId
join Subjects s on d.Id = s.Id
group by f.Name;
go
select t.Name + ' ' + t.Surname as TeacherName, l.LectureRoom, count(*) as LectureCount
from Lectures l
join Teachers t on l.TeacherId = t.Id
group by t.Name, t.Surname, l.LectureRoom;
