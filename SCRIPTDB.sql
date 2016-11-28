
CREATE TABLE [dbo].[StudentCourseEnrollment](
	[ClassEnrollmentID] [int] NOT NULL,
	[CourseID] [int] NULL,
	[StudentID] [int] NULL,
	[Semester] [nvarchar](10) NULL,
	[AcademicYear] [int] NULL,
	[EnrollmentDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ClassEnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students]    Script Date: 11/28/2016 12:53:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[StudentID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Standing] [nvarchar](10) NULL CONSTRAINT [dflt]  DEFAULT ('Freshman'),
 CONSTRAINT [PK__Students__32C52A7929EC1788] PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[vwSpringSemesters]    Script Date: 11/28/2016 12:53:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vwSpringSemesters]
as
select CourseID from StudentCourseEnrollment
where semester = 'spring'
GO
/****** Object:  View [dbo].[vwStudentEnrollment]    Script Date: 11/28/2016 12:53:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vwStudentEnrollment]
as 
select s.FirstName, s.LastName, e.CourseID,c.CourseName, e.AcademicYear, e.Semester 
from StudentCourseEnrollment e inner join Students s
	on e.StudentID = s.StudentID
inner join Courses c on e.CourseID = c.CourseID

GO
ALTER TABLE [dbo].[StudentCourseEnrollment]  WITH CHECK ADD FOREIGN KEY([CourseID])
REFERENCES [dbo].[Courses] ([CourseID])
GO
ALTER TABLE [dbo].[StudentCourseEnrollment]  WITH CHECK ADD  CONSTRAINT [FK__StudentCo__Stude__164452B1] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students] ([StudentID])
GO
ALTER TABLE [dbo].[StudentCourseEnrollment] CHECK CONSTRAINT [FK__StudentCo__Stude__164452B1]
GO
/****** Object:  StoredProcedure [dbo].[archiveStudents]    Script Date: 11/28/2016 12:53:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[archiveStudents]
	
AS
BEGIN
   SET TEXTSIZE 2147483647;

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

insert into CourseReg..archiveStudents
(
  StudentID,
  FirstName,
  LastName,
  Standing
)

select [StudentID], [FirstName], [LastName], [Standing]
from dbo.Students
END

GO
/****** Object:  StoredProcedure [dbo].[pCoursePerSemester]    Script Date: 11/28/2016 12:53:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[pCoursePerSemester] @semester nvarchar (10)
as
select CourseID from StudentCourseEnrollment
where semester = @semester
GO
/****** Object:  StoredProcedure [dbo].[Upsert_Student]    Script Date: 11/28/2016 12:53:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Upsert_Student] 
	@StudentId	INT,
  @FirstName nvarchar (50),
	@LastName nvarchar (50),
	@Standing nvarchar (10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--Start merging: Check if there is such an entry in the database. If FALSE, then Insert
MERGE
	dbo.Students AS target
	USING(
			SELECT
				@StudentId,
				@FirstName,
				@LastName,
				@Standing) AS source
								(
									StudentId,
									FirstName,
									LastName,
									Standing
								)
							ON (target.StudentId = source.StudentId)
							WHEN MATCHED THEN UPDATE
								SET
									target.FirstName = source.FirstName,
									target.LastName = source.LastName,
									target.Standing = source.Standing
							WHEN NOT MATCHED THEN INSERT
							(
								FirstName,
								LastName,
								Standing
							) VALUES (
										source.FirstName,
										source.LastName,
										source.Standing
										);
			SELECT SCOPE_IDENTITY() AS InsertedId;
END

