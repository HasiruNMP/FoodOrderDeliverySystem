using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace FODS_API.Controllers
{
    [Route("user")]
    [ApiController]
    public class UserController : ControllerBase
    {

        private readonly IConfiguration _configuration;
        public UserController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

    }
}
