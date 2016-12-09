namespace WorkshopProject.WebApi.Controllers
{
    using Services;
    using System.Linq;
    using System.Web.Http;
    using System.Web.Http.Cors;

    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class StudentsController : ApiController
    {
        private StudentsService students = new StudentsService();

        //localhost:port/api/students/{id}
        public IHttpActionResult Get(int id)
        {
            var studentToReturn = this.students.StudentGetById(id);

            if (studentToReturn == null)
            {
                return this.NotFound();
            }

            return this.Ok(studentToReturn);
        }

        //localhost:port/api/students
        public IHttpActionResult Get()
        {
            var allStudents = this.students.StudentsGetAll();
            return this.Ok(allStudents);
        }

    }
}
