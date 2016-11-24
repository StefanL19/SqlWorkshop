create table Courses
(
	CourseID int primary key clustered IDENTITY(1,1),
	CourseDesignation nvarchar (8), --BUS250, COS102
	CourseName nvarchar (64)  --Introduction to Microeconomics
)

create table Students
(
	StudentID int primary key clustered IDENTITY(1,1),
	FirstName nvarchar (50),
	LastName nvarchar (50),
	Standing nvarchar (10) constraint dflt default 'Freshman'

)

create table Classes
(
	ClassId	int primary key clustered IDENTITY(1,1),
	ClassName varchar(5), --COS120A, COS120B, etc...
	CourseId int, --
	FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
)

create table StudentClassesEnrollment
(
	CourseID int foreign key references Courses (CourseID),
	StudentID int foreign key references Students (StudentID),
	Semester nvarchar (10), --spring, fall, summer
	AcademicYear int, -- 2015, 2016
	EnrollmentDate date,
	
	constraint enroll_pk primary key  clustered (StudentID, CourseID)
)

------------------------------------------------------------------------------------------------------------------------------------

--Upsert Student Stored procedure

--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE PROCEDURE Upsert_Student 
--	@StudentId	INT,
--  @FirstName nvarchar (50),
--	@LastName nvarchar (50),
--	@Standing nvarchar (10)
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

----Start merging: Check if there is such an entry in the database. If FALSE, then Insert
--MERGE
--	dbo.Students AS target
--	USING(
--			SELECT
--				@StudentId,
--				@FirstName,
--				@LastName,
--				@Standing) AS source
--								(
--									StudentId,
--									FirstName,
--									LastName,
--									Standing
--								)
--							ON (target.StudentId = source.StudentId)
--							WHEN MATCHED THEN UPDATE
--								SET
--									target.FirstName = source.FirstName,
--									target.LastName = source.LastName,
--									target.Standing = source.Standing
--							WHEN NOT MATCHED THEN INSERT
--							(
--								FirstName,
--								LastName,
--								Standing
--							) VALUES (
--										source.FirstName,
--										source.LastName,
--										source.Standing
--										);
--			SELECT SCOPE_IDENTITY();
--END
--GO


------------------------------------------------------------------------------------------------------------------------------------
-- Get All Students

--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE Students_GetAll
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--	SELECT 
--		StudentID,
--		FirstName,
--		Standing
--	FROM dbo.Students
--END
--GO

------------------------------------------------------------------------------------------------------------------------------------

----Select student by Id


--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--CREATE PROCEDURE Students_GetById
--@StudentId		INT
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--	SELECT 
--		StudentID,
--		FirstName,
--		Standing
--	FROM dbo.Students
--	WHERE StudentID = @StudentId
--END
--GO

------------------------------------------------------------------------------------------------------------------------------------

--UPSERT COURSES

--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE PROCEDURE Upsert_Course
--	@CourseID	INT,
--    @CourseDesignation nvarchar(8),
--	@CourseName nvarchar(64)
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

----Start merging: Check if there is such an entry in the database. If FALSE, then Insert
--MERGE
--	dbo.Courses AS target
--	USING(
--			SELECT
--			@CourseID,
--			@CourseDesignation,
--			@CourseName
--				) AS source
--								(
--									CourseID,
--									CourseDesignation,
--									CourseName
--								)
--							ON (target.CourseID = source.CourseID)
--							WHEN MATCHED THEN UPDATE
--								SET
--									target.CourseDesignation = source.CourseDesignation,
--									target.CourseName = source.CourseName
--							WHEN NOT MATCHED THEN INSERT
--							(
--								CourseDesignation,
--								CourseName
--							) VALUES (
--										source.CourseDesignation,
--										source.CourseName
--										);
--			SELECT SCOPE_IDENTITY();
--END
--GO

------------------------------------------------------------------------------------------------------------------------------------

--UPSERT CLASS

--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE PROCEDURE Upsert_Classes
--	@ClassId	INT,
--    @ClassName varchar(5),
--	@CourseId INT
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

----Start merging: Check if there is such an entry in the database. If FALSE, then Insert
--MERGE
--	dbo.Classes AS target
--	USING(
--			SELECT
--			@ClassId,
--			@ClassName,
--			@CourseId
--				) AS source
--								(
--									ClassId,
--									ClassName,
--									CourseId
--								)
--							ON (target.ClassId = source.ClassId)
--							WHEN MATCHED THEN UPDATE
--								SET
--									target.ClassName = source.ClassName,
--									target.CourseId = source.CourseId
--							WHEN NOT MATCHED THEN INSERT
--							(
--								ClassName,
--								CourseId
--							) VALUES (
--										source.ClassName,
--										source.CourseId
--										);
--			SELECT SCOPE_IDENTITY();
--END
--GO

------------------------------------------------------------------------------------------------------------------------------------

--VIEW Entrollment

--create view vwStudentEnrollment
--as 
--select s.FirstName, s.LastName, e.CourseID,c.CourseName, e.AcademicYear, e.Semester from StudentClassesEnrollment e 
--inner join Students s
--on e.StudentID = s.StudentID
--inner join Courses c on e.CourseID = c.CourseID