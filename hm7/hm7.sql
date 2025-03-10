create database Academy;
go
use Academy;
go
create table Assistants(
    AssistantID int not null primary key identity (1,1),
    TeacherID int not null foreign key references Teachers(TeacherID)
)
go
create table Curators(
    CuratorID int not null primary key identity (1,1),
    TeacherID int not null foreign key references Teachers(TeacherID)
)
go
create table Deans(
    DeanID int not null primary key identity (1,1),
    TeacherID int not null foreign key references Teachers(TeacherID)
)
go
create table Departments(
    DepartmentID int not null  primary key identity (1,1),
    DepartmentBuilding int not null check (DepartmentBuilding between 1 and 5),
    DepartmentName nvarchar(100) not null check (DepartmentName <> '') unique ,
    FacultyID int not null foreign key references Faculties(FacultyID),
    HeadID int not null foreign key references Teachers(TeacherID),
)
go
create table Faculties(
    FacultyID int not null primary key identity (1,1),
    FacultyBuilding int not null check (FacultyBuilding between 1 and 5),
    FacultyName nvarchar(100) not null check (FacultyName <> '') unique,
    DeanID int not null foreign key references Deans(DeanID)
)
go
create table Groups(
    GroupID int not null primary key identity (1,1),
    GroupName nvarchar(10) not null check (GroupName <> '') unique,
    DepartmentID int not null foreign key references Departments(DepartmentID)
)
go
create table GroupCurators(
     GroupCuratorID int not null primary key identity (1,1),
    GroupID int not null foreign key references Groups(GroupID),
    CuratorID int not null foreign key references Curators(CuratorID)
)
go
create table GroupLectures(
    GroupLectureID int not null primary key identity (1,1),
    GroupID int not null foreign key references Groups(GroupID),
    LectureID int not null foreign key references Lectures(LectureID)
)
create table Heads(
    HeadID int not null primary key identity (1,1),
    TeacherID int not null foreign key references Teachers(TeacherID)
)
go
create table LectureRoom(
    LectureRoomID int not null primary key identity (1,1),
    LectureRoomBuilding int not null check (LectureRoomBuilding between 1 and 5),
    LectureRoomName nvarchar(100) not null check (LectureRoomName <> '') unique
)
go
create table Lectures(
    LectureID int not null primary key identity (1,1),
    SubjectID int not null foreign key references Subjects(SubjectID),
    TeacherID int not null foreign key references Teachers(TeacherID),
)
go
create table Schedules(
    ScheduleID int not null primary key identity (1,1),
    Class int not null check (Class between 1 and 8),
    DayOfWeek int not null check (DayOfWeek between 1 and 7),
    Week int not null check (Week between 1 and 52),
    LectureID int not null foreign key references Lectures(LectureID),
    LectureRoomID int not null foreign key references LectureRoom(LectureRoomID)
)
go
create table Subjects(
    SubjectID int not null primary key identity (1,1),
    SubjectName nvarchar(100) not null check (SubjectName <> '') unique
)
go
create table Teachers(
    TeacherID int not null primary key identity (1,1),
    TeacherName nvarchar(max) not null check (TeacherName <> ''),
    TeacherSurname nvarchar(max) not null check (TeacherSurname <> ''),
)
go
-- Insert into Teachers
insert into Teachers (TeacherName, TeacherSurname)
values
('John', 'Doe'),
('Jane', 'Smith'),
('Emily', 'Johnson'),
('Michael', 'Brown'),
('Edward', 'Hopper');
go

-- Insert into Deans
insert into Deans (TeacherID)
values
(1),
(2),
(3),
(4),
(5);
go

-- Insert into Faculties
insert into Faculties (FacultyBuilding, FacultyName, DeanID)
values
(1, 'Engineering', 1),
(2, 'Science', 2),
(3, 'Arts', 3),
(4, 'Business', 4),
(5, 'Law', 5);
go

-- Insert into Heads
insert into Heads (TeacherID)
values
(1),
(2),
(3),
(4),
(5);
go

-- Insert into Departments
insert into Departments (DepartmentBuilding, DepartmentName, FacultyID, HeadID)
values
(1, 'Computer Science', 1, 1),
(2, 'Physics', 2, 2),
(3, 'History', 3, 3),
(4, 'Marketing', 4, 4),
(5, 'Criminal Justice', 5, 5);
go

-- Insert into Assistants
insert into Assistants (TeacherID)
values
(1),
(2),
(3),
(4),
(5);
go

-- Insert into Curators
insert into Curators (TeacherID)
values
(1),
(2),
(3),
(4),
(5);
go

-- Insert into Groups
insert into Groups (GroupName, DepartmentID)
values
('CS101', 1),
('PHY101', 2),
('F505', 3),
('MKT101', 4),
('LAW101', 5);
go

-- Insert into GroupCurators
insert into GroupCurators (GroupID, CuratorID)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
go

-- Insert into LectureRoom
insert into LectureRoom (LectureRoomBuilding, LectureRoomName)
values
(1, 'A101'),
(2, 'B202'),
(3, 'C303'),
(4, 'A311'),
(5, 'E505');
go

-- Insert into Subjects
insert into Subjects (SubjectName)
values
('Algorithms'),
('Quantum Mechanics'),
('World History'),
('Software Development'),
('Criminal Law');
go

-- Insert into Lectures
insert into Lectures (SubjectID, TeacherID)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
go

-- Insert into GroupLectures
insert into GroupLectures (GroupID, LectureID)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
go

-- Insert into Schedules
insert into Schedules (Class, DayOfWeek, Week, LectureID, LectureRoomID)
values
(1, 1, 1, 1, 1),
(2, 2, 1, 2, 2),
(3, 3, 1, 3, 3),
(4, 4, 1, 4, 4),
(5, 5, 1, 5, 5);
go
select lr.LectureRoomName
from Lectures l
join Teachers t on l.TeacherID = t.TeacherID
join Schedules s on l.LectureID = s.LectureID
join LectureRoom lr on s.LectureRoomID = lr.LectureRoomID
where t.TeacherName = 'Edward' and t.TeacherSurname = 'Hopper';

go
select t.TeacherSurname
from Lectures l
join Teachers t on l.TeacherID = t.TeacherID
join Assistants a on t.TeacherID = a.TeacherID
join GroupLectures gl on l.LectureID = gl.LectureID
join Groups g on gl.GroupID = g.GroupID
where g.GroupName = 'F505';

go
select s.SubjectName
from Lectures l
join Teachers t on l.TeacherID = t.TeacherID
join Subjects s on l.SubjectID = s.SubjectID
join GroupLectures gl on l.LectureID = gl.LectureID
join Groups g on gl.GroupID = g.GroupID
where t.TeacherName = 'Alex' and t.TeacherSurname = 'Carmack' and g.GroupName like '5%';

go
select distinct t.TeacherSurname
from Teachers t
where t.TeacherID not in (
    select l.TeacherID
    from Lectures l
    join Schedules s on l.LectureID = s.LectureID
    where s.DayOfWeek = 1
);

go
select lr.LectureRoomName, lr.LectureRoomBuilding
from LectureRoom lr
where lr.LectureRoomID not in (
    select s.LectureRoomID
    from Schedules s
    where s.DayOfWeek = 3 and s.Week = 2 and s.Class = 3
);

go
select t.TeacherName, t.TeacherSurname
from Teachers t
join Departments d on t.TeacherID = d.HeadID
join Faculties f on d.FacultyID = f.FacultyID
where f.FacultyName = 'Computer Science' and t.TeacherID not in (
    select c.TeacherID
    from Curators c
    join Groups g on c.TeacherID = g.GroupID
    join Departments d on g.DepartmentID = d.DepartmentID
    where d.DepartmentName = 'Software Development'
);

go
select distinct FacultyBuilding as BuildingNumber from Faculties
union
select distinct DepartmentBuilding from Departments
union
select distinct LectureRoomBuilding from LectureRoom;

go
select t.TeacherName, t.TeacherSurname
from Teachers t
join Deans d on t.TeacherID = d.TeacherID
union
select t.TeacherName, t.TeacherSurname
from Teachers t
join Heads h on t.TeacherID = h.TeacherID
union
select t.TeacherName, t.TeacherSurname
from Teachers t
where t.TeacherID not in (select TeacherID from Deans) and t.TeacherID not in (select TeacherID from Heads)
union
select t.TeacherName, t.TeacherSurname
from Teachers t
join Curators c on t.TeacherID = c.TeacherID
union
select t.TeacherName, t.TeacherSurname
from Teachers t
join Assistants a on t.TeacherID = a.TeacherID
order by TeacherName, TeacherSurname;

go
select distinct s.DayOfWeek
from Schedules s
join LectureRoom lr on s.LectureRoomID = lr.LectureRoomID
where lr.LectureRoomName in ('A311', 'A104');