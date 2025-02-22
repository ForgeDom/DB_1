create database Academy;
go
use Academy;
go
create table Curators(
    CuratorID int primary key not null identity(1,1),
    CuratorName nvarchar(max) not null check (CuratorName <> ''),
    CuratorSurname nvarchar(max) not null check (CuratorSurname <> '')
);
go
create table Departments (
    DepartmentID int primary key not null identity(1,1),
    DepartmentBuilding int not null check (DepartmentBuilding between 1 and 5),
    DepartmentFinancing money not null check (DepartmentFinancing >= 0) default 0,
    DepartmentName nvarchar(100) not null check (DepartmentName <> '') unique,
    DepartmentFacultyID int not null,
    foreign key (DepartmentFacultyID) references Faculties(FacultyID)
);
go
create table Faculties (
    FacultyID int primary key not null identity(1,1),
    FacultyName nvarchar(100) not null check (FacultyName <> '') unique
);
go
create table Groups (
    GroupID int primary key not null identity(1,1),
    GroupName nvarchar(10) not null check (GroupName <> '') unique,
    GroupYear int not null check (GroupYear between 1 and 5),
    GroupDepartmentID int not null,
    foreign key (GroupDepartmentID) references Departments(DepartmentID),
);
go
create table GroupsCurators(
    GroupCuratorID int primary key not null identity(1,1),
    GroupID int not null,
    CuratorID int not null,
    foreign key (GroupID) references Groups(GroupID),
    foreign key (CuratorID) references Curators(CuratorID)
);
go
create table GroupsLectures (
    GroupLectureID int primary key not null identity(1,1),
    GroupID int not null,
    LectureID int not null,
    foreign key (GroupID) references Groups(GroupID),
    foreign key (LectureID) references Lectures(LectureID)
);
go
create table GroupsStudents (
    GroupStudentID int primary key not null identity(1,1),
    GroupID int not null,
    StudentID int not null,
    foreign key (GroupID) references Groups(GroupID),
    foreign key (StudentID) references Students(StudentID)
);
go
create table Lectures (
    LectureID int primary key not null identity(1,1),
    LectureDate date not null default getdate() check (LectureDate <= getdate()),
    LectureSubjectID int not null,
    LectureTeacherID int not null,
    foreign key (LectureSubjectID) references Subjects(SubjectID),
    foreign key (LectureTeacherID) references Teachers(TeacherID)
);
go
create table Students (
    StudentID int primary key not null identity(1,1),
    StudentName nvarchar(max) not null check (StudentName <> ''),
    StudentRating int not null check (StudentRating between 0 and 5),
    StudentSurname nvarchar(max) not null check (StudentSurname <> '')
);
go
create table Subjects (
    SubjectID int primary key not null identity(1,1),
    SubjectName nvarchar(100) not null check (SubjectName <> '') unique
);
go
create table Teachers (
    TeacherID int primary key not null identity (1,1),
    TeacherIsProfessor bit not null default 0,
    TeacherName nvarchar(max) not null check (TeacherName <> ''),
    TeacherSalary money not null check (TeacherSalary > 0),
    TeacherSurname nvarchar(max) not null check (TeacherSurname <> '')
);
go
insert into Curators(CuratorName, CuratorSurname) values
('Michael', 'Johnson'),
('Emily', 'Brown'),
('Christopher', 'Davis'),
('Amanda', 'Miller'),
('Matthew', 'Wilson'),
('Sarah', 'Moore'),
('Joshua', 'Taylor'),
('Jessica', 'Anderson');
go
insert into Departments(DepartmentBuilding, DepartmentFinancing, DepartmentName, DepartmentFacultyID) values
(1, 100000, 'Mathematics Department', 1),
(2, 200000, 'Physics Department', 2),
(3, 300000, 'Chemistry Department', 3),
(4, 400000, 'Biology Department', 4),
(5, 500000, 'Computer Science Department', 5),
(1, 600000, 'Software Development Department', 6);
go
insert into Faculties(FacultyName) values
('Software Development Faculty'),
('Computer Science Faculty'),
('Mathematics Faculty'),
('Physics Faculty'),
('Chemistry Faculty'),
('Biology Faculty');
go
insert into Groups(GroupName, GroupYear, GroupDepartmentID) values
('A110', 1, 15),
('A111', 2, 16),
('A112', 3, 17),
('A113', 4, 18),
('A114', 5, 19),
('B110', 1, 20),
('B111', 2, 28),
('B112', 3, 29),
('B113', 4, 30),
('B114', 5, 31),
('C110', 1, 32),
('C111', 2, 33),
('C112', 3, 15),
('C113', 4, 16),
('C114', 5, 17),
('D110', 1, 18),
('D111', 2, 19),
('D112', 3, 20),
('D113', 4, 28),
('D114', 5, 29),
('D211', 2, 30),
('E110', 1, 31),
('E111', 2, 32),
('E112', 3, 33),
('E113', 4, 15),
('E114', 5, 16),
('F110', 1, 17),
('F111', 2, 18),
('F112', 3, 19),
('F113', 4, 20),
('F114', 5, 28);
go
insert into GroupsCurators(GroupID, CuratorID) values
(5, 1),
(6, 2),
(7, 3),
(8, 4),
(9, 5),
(10, 6),
(11, 7),
(12, 8),
(13, 1),
(14, 2),
(15, 3),
(16, 4),
(17, 5),
(18, 6),
(19, 7),
(20, 8),
(21, 1),
(22, 2),
(23, 3),
(24, 4),
(25, 5),
(26, 6),
(27, 7),
(28, 8),
(29, 1),
(30, 2),
(31, 3),
(32, 4),
(33, 5),
(34, 6),
(35, 7);
go
insert into GroupsLectures(GroupID, LectureID) values
(5, 22),
(6, 23),
(7, 24),
(8, 25),
(9, 26),
(10, 27),
(11, 28),
(12, 29),
(13, 30),
(14, 31),
(15, 32),
(16, 33),
(17, 34),
(18, 35),
(19, 36),
(20, 37),
(21, 38),
(22, 39),
(23, 40),
(24, 41),
(25, 42),
(26, 43),
(27, 44),
(28, 45),
(29, 46),
(30, 47),
(31, 48),
(32, 49),
(33, 50),
(34, 51),
(35, 52);
go
insert into GroupsStudents(GroupID, StudentID) values
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
(32, 32);
go
insert into Lectures(LectureDate, LectureSubjectID, LectureTeacherID) values
('2021-01-01', 4, 1),
('2021-01-02', 3, 2),
('2021-01-03', 5, 3),
('2021-01-04', 1, 4),
('2021-01-05', 2, 5),
('2021-01-06', 6, 6),
('2021-01-07', 4, 7),
('2021-01-08', 3, 8),
('2021-01-09', 5, 1),
('2021-01-10', 1, 2),
('2021-01-11', 2, 3),
('2021-01-12', 6, 4),
('2021-01-13', 4, 5),
('2021-01-14', 3, 6),
('2021-01-15', 5, 7),
('2021-01-16', 1, 8),
('2021-01-17', 2, 1),
('2021-01-18', 6, 2),
('2021-01-19', 4, 3),
('2021-01-20', 3, 4),
('2021-01-21', 5, 5),
('2021-01-22', 1, 6),
('2021-01-23', 2, 7),
('2021-01-24', 6, 8),
('2021-01-25', 4, 1),
('2021-01-26', 3, 2),
('2021-01-27', 5, 3),
('2021-01-28', 1, 4),
('2021-01-29', 2, 5),
('2021-01-30', 6, 6),
('2021-01-31', 4, 7),
('2021-02-01', 3, 8);
go
insert into Students(StudentName, StudentRating, StudentSurname) values
('James', 5, 'Smith'),
('Mary', 4, 'Johnson'),
('John', 3, 'Williams'),
('Patricia', 2, 'Jones'),
('Robert', 1, 'Brown'),
('Linda', 5, 'Davis'),
('Michael', 4, 'Miller'),
('Barbara', 3, 'Wilson'),
('William', 2, 'Moore'),
('Elizabeth', 1, 'Taylor'),
('David', 5, 'Anderson'),
('Jennifer', 4, 'Thomas'),
('Richard', 3, 'Jackson'),
('Susan', 2, 'White'),
('Joseph', 1, 'Harris'),
('Jessica', 5, 'Martin'),
('Thomas', 4, 'Thompson'),
('Sarah', 3, 'Garcia'),
('Charles', 2, 'Martinez'),
('Karen', 1, 'Robinson'),
('Daniel', 5, 'Clark'),
('Nancy', 4, 'Rodriguez'),
('Paul', 3, 'Lewis'),
('Lisa', 2, 'Lee'),
('Mark', 1, 'Walker'),
('Betty', 5, 'Hall'),
('Donald', 4, 'Allen'),
('Sandra', 3, 'Young'),
('Ashley', 2, 'Hernandez'),
('Kenneth', 1, 'King'),
('Dorothy', 5, 'Wright'),
('Steven', 4, 'Lopez'),
('Helen', 3, 'Hill'),
('Carol', 2, 'Scott'),
('Brian', 1, 'Green');
go
insert into Subjects(SubjectName) values
('Mathematics'),
('Physics'),
('Chemistry'),
('Biology'),
('Computer Science'),
('Software Development');
go
insert into Teachers(TeacherIsProfessor, TeacherName, TeacherSalary, TeacherSurname) values
(0, 'Alice', 5000, 'Johnson'),
(0, 'Bob', 6000, 'Williams'),
(0, 'Charlie', 7000, 'Brown'),
(0, 'David', 8000, 'Jones'),
(1, 'Eve', 9000, 'Garcia'),
(1, 'Frank', 10000, 'Martinez'),
(1, 'Grace', 11000, 'Rodriguez'),
(1, 'Helen', 12000, 'Hernandez');
go
select DepartmentBuilding
from Departments
group by DepartmentBuilding
having sum(DepartmentFinancing) > 100000;
go
select g.GroupName
from Groups g
join Departments d on g.GroupDepartmentID = d.DepartmentID
join GroupsLectures gl on g.GroupID = gl.GroupID
join Lectures l on gl.LectureID = l.LectureID
where d.DepartmentName = 'Software Development Department'
  and g.GroupYear = 5
  and datepart(week, l.LectureDate) = 1
group by g.GroupName
having count(l.LectureID) > 10;
go
select g.GroupName
from Groups g
join GroupsStudents gs on g.GroupID = gs.GroupID
join Students s on gs.StudentID = s.StudentID
group by g.GroupName
having avg(s.StudentRating) > (
    select avg(s.StudentRating)
    from Groups g
    join GroupsStudents gs on g.GroupID = gs.GroupID
    join Students s on gs.StudentID = s.StudentID
    where g.GroupName = 'D211'
);
go
select t.TeacherName, t.TeacherSurname
from Teachers t
where t.TeacherSalary > (
    select avg(t.TeacherSalary)
    from Teachers t
    where t.TeacherIsProfessor = 1
);
go
select g.GroupName
from Groups g
join GroupsCurators gc on g.GroupID = gc.GroupID
group by g.GroupName
having count(gc.CuratorID) > 1;
go
select g.GroupName
from Groups g
join GroupsStudents gs on g.GroupID = gs.GroupID
join Students s on gs.StudentID = s.StudentID
group by g.GroupName
having avg(s.StudentRating) < (
    select min(avg_rating)
    from (
        select avg(s.StudentRating) as avg_rating
        from Groups g
        join GroupsStudents gs on g.GroupID = gs.GroupID
        join Students s on gs.StudentID = s.StudentID
        where g.GroupYear = 5
        group by g.GroupID
    ) as subquery
);
go
select f.FacultyName
from Faculties f
join Departments d on f.FacultyID = d.DepartmentFacultyID
group by f.FacultyName
having sum(d.DepartmentFinancing) > (
    select sum(d.DepartmentFinancing)
    from Faculties f
    join Departments d on f.FacultyID = d.DepartmentFacultyID
    where f.FacultyName = 'Computer Science Faculty'
);
go
select s.SubjectName, t.TeacherName + ' ' + t.TeacherSurname as FullName
from Lectures l
join Subjects s on l.LectureSubjectID = s.SubjectID
join Teachers t on l.LectureTeacherID = t.TeacherID
group by s.SubjectName, t.TeacherName, t.TeacherSurname
order by count(l.LectureID) desc;
go
select s.SubjectName
from Lectures l
join Subjects s on l.LectureSubjectID = s.SubjectID
group by s.SubjectName
order by count(l.LectureID) asc;
go
select
    (select count(distinct gs.StudentID)
     from Groups g
     join GroupsStudents gs on g.GroupID = gs.GroupID
     join Departments d on g.GroupDepartmentID = d.DepartmentID
     where d.DepartmentName = 'Software Development Department') as StudentCount,
    (select count(distinct s.SubjectID)
     from Subjects s
     join Lectures l on s.SubjectID = l.LectureSubjectID
     join Departments d on l.LectureSubjectID = d.DepartmentID
     where d.DepartmentName = 'Software Development Department') as SubjectCount;