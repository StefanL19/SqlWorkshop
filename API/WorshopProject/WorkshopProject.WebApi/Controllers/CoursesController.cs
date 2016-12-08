
namespace WorkshopProject.WebApi.Controllers
{
    using Utils;
    using Services;
    using System.Web.Http;

    public class CoursesController : ApiController
    {
        private CoursesService coursesService = new CoursesService();
        
        public IHttpActionResult Get()
        {
            var allCourses = coursesService.GetAllCourses();
            return this.Ok(allCourses);
        }

        [Route("api/courseStudents/{courseId}")]
        public IHttpActionResult GetStudents(int courseId)
        {
            var allCourseStudents = coursesService.GetCourseStudents(courseId);
            return this.Ok(allCourseStudents);
        }

        [HttpPost]
        [Route("api/registerStudent/{courseId}")]
        public IHttpActionResult AddStudent(int courseId, RegisterStudentCourseRequestModel model)
        {
            coursesService.RegisterStudent(courseId, model);
            return this.Ok();
        }
    }
}