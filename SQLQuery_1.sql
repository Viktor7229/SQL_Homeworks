use homework01
--Find all Students with FirstName = Antonio

select *
from Student
where FirstName = 'Viktor'

--Find all Students with DateOfBirth greater than ‘01.01.1999’

select *
from Student
where DateOfBirth > '1999.01.01'

--Find all Male students

select *
from Student
where Gender = 'M'

--Find all Students with LastName starting With ‘T’

select *
from Student
where LastName like 'T%'

--Find all Students Enrolled in January/1998 - NONE

select *
from Student
where EnrolledDate >= '1998.01.01' and EnrolledDate <= '1998.01.31'

--Find all Students with LastName starting With ‘J’ enrolled in January/1998 
-- NONE in January 1998 so i changed the date

select *
from Student
where LastName like 'J%' and EnrolledDate >= '1998.01.01' and EnrolledDate <= '2005.01.31'


--                                              REQUIREMENTS 2/6

--Find all Students with FirstName = Antonio ordered by Last Name

select *
from Student
where FirstName = 'Antonio'
order by LastName asc

--List all Students ordered by FirstName

select *
from Student
order by FirstName asc

--Find all Male students ordered by EnrolledDate, starting from the last enrolled

select *
from Student
where Gender = 'M'
order by EnrolledDate desc


--                                              REQUIREMENTS 3/6

--List all Teacher First Names and Student First Names in single result set with duplicates

select t.FirstName as TeacherName, s.FirstName as StudentName
from Teacher t
full join Student s 
on t.ID = s.ID

--List all Teacher Last Names and Student Last Names in single result set. Remove duplicates

select distinct t.LastName as TeacherLastName, s.LastName as StudentLastName
from Teacher t
full join Student s 
on t.ID = s.ID

--List all common First Names for Teachers and Students

select FirstName, count(FirstName) as NameCount
from Teacher
group by FirstName
order by NameCount desc

select FirstName, count(FirstName) as NameCount
from Student
group by FirstName
order by NameCount desc


-- FAILED ATTEMPT TO COMBINE BOTH
select distinct s.FirstName, count(s.FirstName) StudentNameCount,
	   t.FirstName, count(t.FirstName) TeacherNameCount
from Student s
full join Teacher t
on s.ID = t.ID
group by s.FirstName,t.FirstName
order by TeacherNameCount,StudentNameCount desc



--                                              REQUIREMENTS 4/6

--Change GradeDetails table always to insert value 100 in AchievementMaxPoints column if no value is provided on insert

select *
from GradeDetails

alter table GradeDetails
add constraint Default_AchievementPoints
default 100 for AchievementPoints

-- TESTING THE CONSTRAINT
insert into GradeDetails(GradeID,AchievementTypeID,AchievementMaxPoints,AchievementDate)
values('20503',3 ,100, '')


--Change GradeDetails table to prevent inserting AchievementPoints that will more than AchievementMaxPoints

select *
from GradeDetails
where AchievementPoints = 100

alter table GradeDetails
ADD CONSTRAINT CHK_AchievementPointsLimit CHECK (AchievementPoints <= 100)

-- TESTING
insert into GradeDetails(GradeID,AchievementTypeID,AchievementPoints,AchievementMaxPoints,AchievementDate)
values('20503',3,101,100, '')

--Change AchievementType table to guarantee unique names across the Achievement types

select *
from AchievementType

ALTER TABLE AchievementType
ADD CONSTRAINT Unique_AchievementTypeName UNIQUE ([Name]);

-- TESTING
insert into AchievementType([Name],ParticipationRate)
values('Ispit',40)


--                                              REQUIREMENTS 5/6

--Create Foreign key constraints from diagram or with script

alter table Grade
add constraint FK_Student
foreign key (StudentID) references Student(ID)

alter table Grade
add constraint FK_Course
foreign key (CourseID) references Course(ID)

alter table Grade
add constraint FK_Teacher
foreign key (TeacherID) references Teacher(ID)

alter table GradeDetails
add constraint FK_Grade
foreign key (GradeID) references Grade(ID)

alter table GradeDetails
add constraint FK_AchievementType
foreign key (AchievementTypeID) references AchievementType(ID)


--                                              REQUIREMENTS 6/6

--List all possible combinations of Courses names and AchievementType names that can be passed by student

select c.[Name] as CourseNames, 
	   a.[Name] as AchievementTypeNames
from Course c
full join AchievementType a on a.ID = c.ID

--List all Teachers that has any exam Grade

select t.ID as TeacherID, t.FirstName as TeacherFirstName, t.LastName as TeacherLastName
from Grade g
right join Teacher t on g.TeacherID = t.ID
where g.Grade is not null


--List all Teachers without exam Grade

select t.ID as TeacherID, t.FirstName as TeacherFirstName, t.LastName as TeacherLastName
from Grade g
right join Teacher t on g.TeacherID = t.ID
where g.Grade is null

--List all Students without exam Grade (using Right Join)

select *
from Grade g
right join Student s on g.StudentID = s.ID
where g.StudentID is null

















-- TESTING
select * from AchievementType
select * from GradeDetails
select * from Grade
select * from Course
select * from Teacher
select * from Student

select t.ID as TeacherID, t.FirstName as TeacherFirstName, t.LastName as TeacherLastName, 
	   s.FirstName as StudentFirstName, s.LastName as StudentLastName,
	   c.[Name] as NameOfCourse,
	   g.Grade as GradeOnCourse
from Grade g
inner join Teacher t on g.TeacherID = t.ID
inner join Student s on g.StudentID = s.ID
inner join Course c on g.CourseID = c.ID
