
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Utils;
using WorkshopProject.Data;

namespace WorkshopProject.Services
{
    public class CoursesService
    {
        public ICollection<Courses_GetAll_Result> GetAllCourses()
        {
            using (var db = new CourseRegistrationDbEntities())
            {
                return db.Courses_GetAll().ToList();
            }
        }

        public ICollection<Courses_GetStudents_Result> GetCourseStudents(int courseId)
        {
            using (var db = new CourseRegistrationDbEntities())
            {
                return db.Courses_GetStudents(courseId).ToList();
            }
        }

        public bool RegisterStudent(int courseId, RegisterStudentCourseRequestModel model)
        {
            using (var db = new CourseRegistrationDbEntities())
            {
                 db.Course_RegisterStudent(courseId, model.StudentId, model.Semester, model.AcademicYear);
                return true;
            }
        }
    }
}
