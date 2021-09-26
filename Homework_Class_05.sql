--                                   REQUIREMENTS 1/1

--Create multi-statement table value function that for specific Teacher and Course will 
--return list of students (FirstName, LastName) who passed the exam, together with Grade and CreatedDate
go
alter function fn_StudentsThatPassedTheExam(@TeacherFirstName nvarchar(50), @TeacherLastName nvarchar(50), @CourseID int)
returns @output table (StudentFirstName nvarchar(30),
					   StudentLastName nvarchar(30),
					   Grade int,
					   CreatedDate date)
as
begin

	insert into @output
	select 
		   s.FirstName as StudentFirstName,
		   s.LastName as StudentLastName,
		   g.Grade as StudentGrade,
		   g.CreatedDate as GradeCreatedDate
	from Grade g
	inner join Teacher t on g.TeacherID = t.ID
	inner join Student s on g.StudentID = s.ID
	inner join Course c on  g.CourseID = c.ID
	where t.FirstName = @TeacherFirstName and t.LastName = @TeacherLastName and c.ID = @CourseID
	return

end
go
-- YOU CAN FIND COURSE ID IN vv_Teacher_Course VIEW
select * from fn_StudentsThatPassedTheExam('Milica', 'Mihajlovska', 2)



go
create view vv_Teacher_Course
as
select distinct 
				t.FirstName as Teacher_FirstName,
				t.LastName as Teacher_LastName,
				c.ID as CourseID ,
				c.[Name] as Course_Name
from Course c
inner join Grade g on g.CourseID = c.ID
inner join Teacher t on g.TeacherID = t.ID

go
-- CHECK TEACHERS AND COURSES THEY TEACH
select * from vv_Teacher_Course
order by CourseID