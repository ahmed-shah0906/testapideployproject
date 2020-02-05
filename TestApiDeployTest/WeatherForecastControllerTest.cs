using Microsoft.VisualStudio.TestTools.UnitTesting;
using TestAPIDeplo.Controllers;

namespace TestApiDeployTest
{
    [TestClass]
    public class WeatherForecastControllerTest
    {
        [TestMethod]
        public void Test_Get()
        {
            WeatherForecastController wtc = new WeatherForecastController();
            var teststring = wtc.Get();
            Assert.IsTrue(teststring != null);
        }
    }
}
