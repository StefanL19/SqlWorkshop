USE [master]
GO
/****** Object:  Database [CourseRegistrationDb]    Script Date: 12/1/2016 7:37:59 PM ******/
CREATE DATABASE [CourseRegistrationDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CourseRegistrationDb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\CourseRegistrationDb.mdf' , SIZE = 3264KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CourseRegistrationDb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\CourseRegistrationDb_log.ldf' , SIZE = 816KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CourseRegistrationDb] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CourseRegistrationDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CourseRegistrationDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CourseRegistrationDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CourseRegistrationDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CourseRegistrationDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CourseRegistrationDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET RECOVERY FULL 
GO
ALTER DATABASE [CourseRegistrationDb] SET  MULTI_USER 
GO
ALTER DATABASE [CourseRegistrationDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CourseRegistrationDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CourseRegistrationDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CourseRegistrationDb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [CourseRegistrationDb] SET DELAYED_DURABILITY = DISABLED 
GO
USE [CourseRegistrationDb]
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[CourseID] [int] NOT NULL,
	[CourseDesignation] [nvarchar](8) NULL,
	[CourseName] [nvarchar](64) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [courses_clIdx]    Script Date: 12/1/2016 7:37:59 PM ******/
CREATE CLUSTERED INDEX [courses_clIdx] ON [dbo].[Courses]
(
	[CourseDesignation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentCourseEnrollment]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentCourseEnrollment](
	[ClassEnrollmentID] [int] IDENTITY(1,1) NOT NULL,
	[CourseID] [int] NULL,
	[StudentID] [int] NULL,
	[Semester] [nvarchar](10) NULL,
	[AcademicYear] [int] NULL,
	[EnrollmentDate] [date] NULL,
 CONSTRAINT [PK__StudentC__358F4FD7A89FF607] PRIMARY KEY CLUSTERED 
(
	[ClassEnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students]    Script Date: 12/1/2016 7:37:59 PM ******/
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
/****** Object:  View [dbo].[vwSpringSemesters]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vwSpringSemesters]
as
select CourseID from StudentCourseEnrollment
where semester = 'spring'
GO
/****** Object:  View [dbo].[vwStudentEnrollment]    Script Date: 12/1/2016 7:37:59 PM ******/
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
INSERT [dbo].[Courses] ([CourseID], [CourseDesignation], [CourseName]) VALUES (1, N'BUS200', N'BUS')
SET IDENTITY_INSERT [dbo].[StudentCourseEnrollment] ON 

INSERT [dbo].[StudentCourseEnrollment] ([ClassEnrollmentID], [CourseID], [StudentID], [Semester], [AcademicYear], [EnrollmentDate]) VALUES (1, 1, 1, N'Spring', 2016, CAST(N'2016-12-01' AS Date))
INSERT [dbo].[StudentCourseEnrollment] ([ClassEnrollmentID], [CourseID], [StudentID], [Semester], [AcademicYear], [EnrollmentDate]) VALUES (2, 1, 2, N'Spring', 2016, CAST(N'2016-12-01' AS Date))
INSERT [dbo].[StudentCourseEnrollment] ([ClassEnrollmentID], [CourseID], [StudentID], [Semester], [AcademicYear], [EnrollmentDate]) VALUES (3, 1, 3, N'Asd', 2015, CAST(N'2011-11-11' AS Date))
INSERT [dbo].[StudentCourseEnrollment] ([ClassEnrollmentID], [CourseID], [StudentID], [Semester], [AcademicYear], [EnrollmentDate]) VALUES (4, 1, 3, N'Spring', 2016, CAST(N'2016-12-01' AS Date))
SET IDENTITY_INSERT [dbo].[StudentCourseEnrollment] OFF
SET IDENTITY_INSERT [dbo].[Students] ON 

INSERT [dbo].[Students] ([StudentID], [FirstName], [LastName], [Standing]) VALUES (1, N'Stefan', N'Lazov', N'Sophomore')
INSERT [dbo].[Students] ([StudentID], [FirstName], [LastName], [Standing]) VALUES (2, N'Stefan', N'Lazov', N'Sophomore1')
INSERT [dbo].[Students] ([StudentID], [FirstName], [LastName], [Standing]) VALUES (3, N'TDD', N'100', N'Freshman')
SET IDENTITY_INSERT [dbo].[Students] OFF
/****** Object:  Index [PK__Courses__C92D7186FAA6BC1B]    Script Date: 12/1/2016 7:37:59 PM ******/
ALTER TABLE [dbo].[Courses] ADD PRIMARY KEY NONCLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StudentCourseEnrollment]  WITH CHECK ADD  CONSTRAINT [FK__StudentCo__Cours__15502E78] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Courses] ([CourseID])
GO
ALTER TABLE [dbo].[StudentCourseEnrollment] CHECK CONSTRAINT [FK__StudentCo__Cours__15502E78]
GO
ALTER TABLE [dbo].[StudentCourseEnrollment]  WITH CHECK ADD  CONSTRAINT [FK__StudentCo__Stude__164452B1] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students] ([StudentID])
GO
ALTER TABLE [dbo].[StudentCourseEnrollment] CHECK CONSTRAINT [FK__StudentCo__Stude__164452B1]
GO
/****** Object:  StoredProcedure [dbo].[archiveStudents]    Script Date: 12/1/2016 7:37:59 PM ******/
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
/****** Object:  StoredProcedure [dbo].[Course_RegisterStudent]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Course_RegisterStudent]
@CourseId	INT,
@StudentId	INT,
@Semester	NVARCHAR(10),
@AcademicYear INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO dbo.StudentCourseEnrollment
	(CourseID, StudentID, Semester, AcademicYear, EnrollmentDate)
	VALUES
	(@CourseId, @StudentId, @Semester, @AcademicYear, GETUTCDATE())
END

GO
/****** Object:  StoredProcedure [dbo].[Courses_GetAll]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Courses_GetAll]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM dbo.Courses;
END

GO
/****** Object:  StoredProcedure [dbo].[Courses_GetById]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Courses_GetById]
@Id	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM dbo.Courses
	WHERE CourseID = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[Courses_GetStudents]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Courses_GetStudents]
@CourseId	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT s.FirstName, s.LastName, s.Standing
	FROM dbo.Courses as c inner join dbo.StudentCourseEnrollment sce on c.CourseID = sce.CourseID inner join dbo.Students as s on sce.StudentID = s.StudentID
	WHERE c.CourseID = @CourseId;
END

GO
/****** Object:  StoredProcedure [dbo].[pCoursePerSemester]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[pCoursePerSemester] @semester nvarchar (10)
as
select CourseID from StudentCourseEnrollment
where semester = @semester
GO
/****** Object:  StoredProcedure [dbo].[Student_GetAll]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Student_GetAll]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM dbo.Students;
END

GO
/****** Object:  StoredProcedure [dbo].[Students_GetById]    Script Date: 12/1/2016 7:37:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Students_GetById]
@Id	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM dbo.Students
	WHERE StudentID = @Id;
END

GO
/****** Object:  StoredProcedure [dbo].[Upsert_Student]    Script Date: 12/1/2016 7:37:59 PM ******/
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

GO
USE [master]
GO
ALTER DATABASE [CourseRegistrationDb] SET  READ_WRITE 
GO
