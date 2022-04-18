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
    [Route("products")]
    [ApiController]
    public class ProductController : ControllerBase
    {

        private readonly IConfiguration _configuration;
        public ProductController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost,Route("postproduct")]
        public JsonResult PostProduct(int CategoryId,string Name,string Description,float Price,string ImgUrl)
        {
            string query = @"insert into [dbo].[PRODUCTS] values("+CategoryId+",'"+Name+"','"+Description+"',"+Price+",'"+ImgUrl+"')";
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
            return new JsonResult("Added Successfully");
        }

         [HttpGet, Route("getcategoryproducts")]
        public JsonResult GetCategoryProducts(int categoryId)
        {
            string query = @"SELECT * FROM [dbo].[PRODUCTS] WHERE CategoryId =" + categoryId;
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

         [HttpPut,Route("putproductdetails")]
        public JsonResult PutProductDetails(int ProductId,int CategoryId,string Name,string Description,float Price,string ImgUrl)
        {
            string query = @"UPDATE [dbo].[PRODUCTS] SET CategoryId = " + CategoryId + ",Name = '" + Name + "',Description = '" + Description + "',Price = " + Price + ",ImgUrl = '" + ImgUrl + "' WHERE ProductId =" + ProductId;
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

         [HttpDelete]
        public JsonResult DeleteProduct(int ProductId)
        {
            string query = @"delete from dbo.PRODUCTS where ProductId="+ProductId;
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
            return new JsonResult("Deleted Successfully!");
        }

    }
}
