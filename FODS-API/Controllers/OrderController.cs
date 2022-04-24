using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace FODS_API.Controllers
{
    [Route("orders")]
    [ApiController]
    public class OrderController : ControllerBase
    {

        private readonly IConfiguration _configuration;
        public OrderController(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        [HttpGet, Route("getneworderslist")]
        public JsonResult getNewOrders(int userId)
        {
            string query = @"SELECT * FROM [dbo].[ORDERS] WHERE UserId='" + userId + "' AND OrderStatus='pending' OR OrderStatus='new'";
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

        [HttpGet, Route("getcompletedlist")]
        public JsonResult getCompletedOrders(int userId)
        {
            string query = @"SELECT * FROM [dbo].[ORDERS] WHERE UserId='" + userId + "' AND OrderStatus='completed'";
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


        [HttpGet, Route("getOrderItems")]
        public JsonResult getOrderItems(int orderId)
        {
            string query = @"SELECT * FROM [dbo].[ORDER_ITEMS] WHERE OrderId='" + orderId + "'";
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


        [HttpGet, Route("getproductdetails")]
        public JsonResult getProductDetails(int productId)
        {
            string query = @"SELECT * FROM [dbo].[PRODUCTS] WHERE ProductId='" + productId + "'";
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

        [HttpPut, Route("updateorderstatus")]
        public JsonResult updateOrderStatus(int orderId,String orderStatus)
        {
            string query = @"UPDATE dbo.ORDERS SET OrderStatus='" + orderStatus + "' WHERE OrderId='"+orderId+"' ";
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
                }
            }
            return new JsonResult("Updated Successfully!");
        }

        [HttpGet, Route("fetchneworders")]
        public JsonResult fetchNewOrders()
        {
            string query = @"SELECT * FROM [dbo].[ORDERS] WHERE IsProcessed =0";
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

        [HttpGet, Route("getprocessedorders")]
        public JsonResult GetProcessedOrders()
        {
            string query = @"SELECT * FROM [dbo].[ORDERS] WHERE IsProcessed != 0 AND (IsReceived = 0 OR IsDelivered = 0)";
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

        [HttpGet, Route("getcompletedorders")]
        public JsonResult GetCompletedOrders()
        {
            string query = @"SELECT * FROM [dbo].[ORDERS] WHERE IsReceived != 0 AND IsDelivered != 0";
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

        [HttpPut, Route("putprocessed")]
        public JsonResult PutProcessed(int orderId,int empId)
        {
            string query = @"UPDATE [dbo].[ORDERS] SET IsProcessed =1, EmployeeId='"+empId+"',  OrderStatus='processed' WHERE OrderId =" + orderId;
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
            return new JsonResult("Updated Successfully");
        }

        [HttpGet, Route("getorderlist")]
        public JsonResult getOrderlist(int EmployeeId)
        {
            string query = @"SELECT * FROM [dbo].[OrderDetails] WHERE EmployeeId='" + EmployeeId + "' AND OrderStatus='pending'";
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
