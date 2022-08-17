using AOVI_EXE.Models;
using GalaSoft.MvvmLight.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.IE;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;

namespace AOVI_EXE
{
    /// <summary>
    /// App.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class App : Application
    {
        enum RunOption { Normal, Fail, Error }

        RunOption _runOption = RunOption.Normal;

        App()
        {
            try
            {
                DispatcherHelper.Initialize();

                //using (IWebDriver driver = new InternetExplorerDriver())
                //{
                //    driver.Url = "https://www.naver.com/";
                //}

                Common com = new Common();
                com.DataReceived();
            }
            catch(Exception ex)
            {

            }
        }


    }
}
