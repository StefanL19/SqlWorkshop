using System.Collections;
using System.Collections.Generic;
using System.Linq;
using WorkshopProject.Data;

namespace WorkshopProject.Services
{
    public class StudentsService
    {
        //Students get by Id 
        public Students_GetById_Result StudentGetById(int id)
        {
            using (var db = new CourseRegistrationDbEntities())
            {
                return db.Students_GetById(id).SingleOrDefault();
            }
        }

        public ICollection<Student_GetAll_Result> StudentsGetAll()
        {
            using (var db = new CourseRegistrationDbEntities())
            {
                return db.Student_GetAll().ToList();
            }
        }
    }
}
