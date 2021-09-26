use homework

--                                              REQUIREMENTS 1/3


--Calculate the count of all grades in the system

select sum(Grade) as Sum_Grades
from Grade

--Calculate the count of all grades per Teacher in the system

select t.FirstName,t.LastName, 
	   count(g.Grade) as Teacher_TotalGrades
from Grade g
inner join Teacher t on g.TeacherID = t.ID
group by t.FirstName,t.LastName

--Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100)

select t.FirstName,t.LastName, 
	   count(g.Grade) as Teacher_TotalGrades
from Grade g
inner join Teacher t on g.TeacherID = t.ID
inner join Student s on g.StudentID = s.ID
where StudentID < 100
group by t.FirstName,t.LastName
order by t.FirstName

--Find the Maximal Grade, and the Average Grade per Student on all grades in the system

select max(g.Grade) as Maximal_SystemGrades, avg(g.Grade) as Average_SystemGrades
from Grade g
inner join Student s on g.StudentID = s.ID


--                                              REQUIREMENTS 2/3


--Calculate the count of all grades per Teacher in the system and filter only grade count greater then 200

select t.FirstName,t.LastName, 
	   count(g.Grade) as Teacher_TotalGrades
from Grade g
inner join Teacher t on g.TeacherID = t.ID
group by t.FirstName,t.LastName
having count(g.Grade) > 200

--Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100) 
--and filter teachers with more than 50 Grade count

select t.FirstName,t.LastName, 
	   count(g.Grade) as Teacher_TotalGrades
from Grade g
inner join Teacher t on g.TeacherID = t.ID
inner join Student s on g.StudentID = s.ID
where StudentID < 100
group by t.FirstName,t.LastName
having count(g.Grade) > 50
order by t.FirstName

--Find the Grade Count, Maximal Grade, and the Average Grade per Student on all grades in the system. 
--Filter only records where Maximal Grade is equal to Average Grade
go
create view vv_Equal_Max_Avg_Grades
as
select s.ID,
	   max(g.Grade) as Maximal_Grade, avg(g.Grade) as Average_Grade
from Grade g
inner join Student s on g.StudentID = s.ID
group by s.ID
having max(g.Grade) = avg(g.Grade)
go

--List Student First Name and Last Name next to the other details from previous query

select s.FirstName, s.LastName,
	   eq.Maximal_Grade, eq.Average_Grade
from vv_Equal_Max_Avg_Grades eq
inner join Student s on eq.ID = s.ID
group by s.FirstName, s.LastName, eq.Maximal_Grade, eq.Average_Grade


--                                              REQUIREMENTS 3/3


--Create new view (vv_StudentGrades) that will List all StudentIds and count of Grades per student
go
create view vv_StudentGrades
as
select g.StudentID, count(g.Grade) as Count_Grade
from Grade g
inner join Student s on g.StudentID = s.ID
group by g.StudentID
go

select *
from vv_StudentGrades

--Change the view to show Student First and Last Names instead of StudentID
go
create view vv_StudentGradesWithNames
as
select s.FirstName, s.LastName, sg.Count_Grade
from vv_StudentGrades sg
inner join Student s on sg.StudentID = s.ID
group by s.FirstName, s.LastName, sg.Count_Grade
go

--List all rows from view ordered by biggest Grade Count

select *
from vv_StudentGradesWithNames
order by Count_Grade desc

--Create new view (vv_StudentGradeDetails) that will List all Students (FirstName and LastName) 
--and Count the courses he passed through the exam(Ispit)

select s.FirstName, s.LastName,
	   count(c.ID) as CoursesPassed
from Grade g
inner join Student s on g.StudentID = s.ID
inner join Course c on g.CourseID = c.ID 
group by s.FirstName, s.LastName

