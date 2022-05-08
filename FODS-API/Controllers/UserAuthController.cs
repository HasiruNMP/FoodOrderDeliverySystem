using FODS_API.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Twilio;
using Twilio.Rest.Api.V2010.Account;

namespace FODS_API.Controllers
{
    [Route("auth")]
    [ApiController]
    public class UserAuthController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public UserAuthController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        private UserAuth GetCurrentUser()
        {
            var identity = HttpContext.User.Identity as ClaimsIdentity;

            if (identity != null)
            {
                var userClaims = identity.Claims;

                return new UserAuth
                {
                    UserType = userClaims.FirstOrDefault(o => o.Type == ClaimTypes.Role)?.Value
                };
            }
            return null;
        }


        [HttpPost, Route("req-otp")]
        public ActionResult RequestOTP(string phoneNo)
        {
            string otp = "0";

            string query = $@"SELECT * FROM dbo.USER_AUTH WHERE UserID ='" + phoneNo + "'";

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

            if (table.Rows.Count == 1)
            {
                otp = GenerateOTP(phoneNo);
                int x = SendOTP(otp,phoneNo);
                return Ok(x);
            }
            else
            {
                otp = NewUserGenerateOTP(phoneNo);
                int x = SendOTP(otp,phoneNo);
                return NotFound();
            }
        }

        private string GenerateOTP(string phone)
        {
            Random generator = new Random();
            string otp = generator.Next(100000, 1000000).ToString();

            string query = $@"UPDATE [dbo].[USER_AUTH] SET Password = '{otp}' WHERE UserID = '{phone}';";

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

            return otp;
        }

        private string NewUserGenerateOTP(string phone)
        {
            Random generator = new Random();
            string otp = generator.Next(100000, 1000000).ToString();

            string query = $@"INSERT INTO [dbo].[USER_AUTH] VALUES ('{phone}','{otp}','CS');";

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

            return otp;
        }

        private int SendOTP(string otp,string phone)
        {
            /*string accountSid = "AC0af284e07dd78c2b827ec036ba464315";
            string authToken = "388f87fc7fc687da4f6cd9653ba7ab7b";

            TwilioClient.Init(accountSid, authToken);

            var message = MessageResource.Create(
                body: $"Welcome to FODS! Your OTP is {otp}",
                from: new Twilio.Types.PhoneNumber("+19289853180"),
                to: new Twilio.Types.PhoneNumber(phone)
            );*/
            return 1;
        }

        [HttpPost, Route("login")]
        public ActionResult Login(UserAuth toLogin)
        {
            UserAuth? user = AuthenticateUser(toLogin);

            if (user != null)
            {
                var token = GenerateToken(user);
                return Ok(token);
            }

            return NotFound("User Not Found");
        }

        private string GenerateToken(UserAuth user)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(ClaimTypes.Role, user.UserType)
            };

            var token = new JwtSecurityToken(_configuration["Jwt:Issuer"],
              _configuration["Jwt:Audience"],
              claims,
              expires: DateTime.Now.AddDays(30),
              signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        private UserAuth? AuthenticateUser(UserAuth toLogin)
        {
            UserAuth newUser = new UserAuth();

            string query = $@"SELECT UserID,Password,UserType
                FROM dbo.USER_AUTH
                Where UserID ='" + toLogin.UserID +
                "'  AND Password ='" + toLogin.Password +
                "' AND UserType ='" + toLogin.UserType +
                "'";

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

            if (table.Rows.Count == 1)
            {
                newUser.UserID = table.Rows[0]["UserID"].ToString();
                newUser.Password = table.Rows[0]["Password"].ToString();
                newUser.UserType = table.Rows[0]["UserType"].ToString();
                return newUser;
            }
            else
            {
                return null;
            }
        }


    }
}
