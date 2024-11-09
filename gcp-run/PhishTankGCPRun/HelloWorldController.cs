using Microsoft.AspNetCore.Mvc;

namespace PhishTankGCPRun
{
    public class HelloWorldController : ControllerBase
    {
        [Route("helloworld")]
        public ActionResult<string> Get()
        {
            return "Hello World!!";
        }
    }
}
