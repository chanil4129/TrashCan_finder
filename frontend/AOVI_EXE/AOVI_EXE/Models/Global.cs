using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace AOVI_EXE.Models
{
    public class Global
    {
        public static int order { get; set; }              //홈페이지 데이터를 담은 List를 순서대로 부를때 쓰는 변수
        public static string url { get; set; } = "";       //홈페이지 url주소 담아두는 변수

        public static void WebUrl() 
        {
            try
            {
                using(IWebDriver driver = new ChromeDriver())
                {
                    string url = driver.Url;
                }
            }
            catch (Exception ex)
            {

            }
        }
    }
}
