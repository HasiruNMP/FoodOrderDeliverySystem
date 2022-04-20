using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace FODS_API.Controllers
{
    [Route("employee")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {

        private readonly IConfiguration _configuration;
        public EmployeeController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet, Route("getDeliveryEmployeesDetails")]
        public JsonResult getDeliveryEmployees()
        {
            string query = @"select * from dbo.EMPLOYEES
            Where Department ='Delivery' ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("FODSDB");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();

                }
            }
            return new JsonResult(table);
        }

        [HttpGet, Route("getemployeedetails")]
        public JsonResult getEmployeeDetails(int empId)
        {
            string query = @"select * from dbo.EMPLOYEES
            Where  EmployeeId ='"+empId+"' ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("FODSDB");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();

                }
            }
            return new JsonResult(table);
        }

    }
}
