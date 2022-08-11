using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.IE;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace AOVI_EXE.Models
{
    public class Global
    {
        public static int Linkorder { get; set; }               //홈페이지 링크 데이터를 담은 List를 순서대로 부를때 쓰는 변수
        public static string url { get; set; } = "";            //홈페이지 url주소 담아두는 변수
        public static int Textorder { get; set; }               //홈페이지 텍스트 테이터를 담은 List를 순서대로 부를때 쓰는 변수>
        public IWebDriver serverDriver;

        /// <summary>
        /// 중복 초기화 방지 변수
        /// </summary>
        public bool InitializeStarted { get; private set; } = false;

        public static void WebUrl() 
        {
            try
            {
                using(IWebDriver driver = new InternetExplorerDriver())
                {
                    driver.Url = "https://www.naver.com/";
                }
            }
            catch (Exception ex)
            {

            }
        }

        /// <summary>
        /// 초기화
        /// </summary>
        public void Initialize()
        {
            if (InitializeStarted)
            {
                return;
            }
            InitializeStarted = true;
            Task.Run(async () =>
            {
                try
                {
                    ///1. 이미 실행중인 edge을 모두 강제종료
                    foreach (var x in Process.GetProcessesByName("edge"))
                    {
                        try
                        {
                            x.Kill();
                        }
                        catch (Exception e)
                        {
                        }
                    }

                }
                catch { }
            });
        }
    }
}
