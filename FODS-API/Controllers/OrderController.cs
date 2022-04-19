using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using FODS_API.Models;

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
            string query = @"SELECT * FROM [dbo].[ORDERS] WHERE UserId='" + userId + "' AND OrderStatus='pending'";
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

         [HttpGet, Route("getneworders")]
        public JsonResult GetNewOrders()
        {
            string query = @"SELECT * FROM [dbo].[ORDERS] WHERE IsProcessed = 0";
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

        [HttpGet, Route("getorderitems")]
        public JsonResult GetOrderItems(int orderId)
        {
            string query = @"SELECT * FROM [dbo].[ORDER_ITEMS] WHERE OrderId = " + orderId;
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

        [HttpPut,Route("putprocessed")]
        public JsonResult PutProcessed(int orderId)
        {
            string query = @"UPDATE [dbo].[ORDERS] SET IsProcessed = 1 WHERE OrderId =" + orderId;
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

    }
}
