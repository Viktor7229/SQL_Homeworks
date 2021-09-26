use homework
--                                   REQUIREMENTS 1/2
--Declare scalar variable for storing FirstName values
	--Assign value ‘Viktor’ to the FirstName variable
	--Find all Students having FirstName same as the variable

declare @FirstName nvarchar(50)
set @FirstName = 'Viktor'

select *
from Student
where FirstName = @FirstName


--Declare table variable that will contain StudentId, StudentName and DateOfBirth
	--Fill the table variable with all Female students

declare @StudentInfo table (StudentId int, StudentName nvarchar(50), DateOfBirth date)
insert into @StudentInfo (StudentId, StudentName, DateOfBirth)
select ID, FirstName, DateOfBirth
from Student

select * from @StudentInfo

--Declare temp table that will contain LastName and EnrolledDate columns
	--Fill the temp table with all Male students having First Name starting with ‘A’
	--Retrieve the students from the table which last name is with 7 characters
go
create table #EnrolledStudents (LastName nvarchar(50), EnrolledDate date)
insert into #EnrolledStudents(LastName, EnrolledDate)
select LastName, EnrolledDate
from Student
where Gender = 'M' and FirstName like 'V%' and len(LastName) != 7


select * from #EnrolledStudents
go

drop table #EnrolledStudents

--Find all teachers whose FirstName length is less than 5 and
	--the first 3 characters of their FirstName and LastName are the same

select *
from Teacher
where left(FirstName,3) = left(LastName,3) and len(firstname) <= 5 -- LESS THAN 5 - NONE




--                                   REQUIREMENTS 2/2

--Declare scalar function (fn_FormatStudentName) for retrieving the 
--Student description for specific StudentId in the following format:
	--StudentCardNumber without “sc-”
	--“ – “
	--First character of student FirstName
	--“.”
	--Student LastName

go
create function fn_FormatStudentName(@StudentID int)
returns nvarchar(50)
as
begin

	declare @output nvarchar(50)
	
	select @output = substring(StudentCardNumber,4,5) +' '+ '-' +' '+ left(firstname,1) + '.' + LastName
	from Student
	where ID = @StudentID
	return @output
end

select *, dbo.fn_FormatStudentName(ID) as FormattedStudent
from Student


