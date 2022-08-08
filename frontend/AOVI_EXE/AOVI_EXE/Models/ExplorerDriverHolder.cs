using OpenQA.Selenium.IE;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AOVI_EXE.Models
{
    public class ExplorerDriverHolder
    {

        private static readonly Lazy<ExplorerDriverHolder> _instance = new Lazy<ExplorerDriverHolder>(() => new ExplorerDriverHolder());
        public static ExplorerDriverHolder Instance
        {
            get
            {
                return _instance.Value;
            }
        }
        /// <summary>
        /// 중복 초기화 방지 변수
        /// </summary>
        public bool InitializeStarted { get; private set; } = false;

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
                    foreach (var x in Process.GetProcessesByName("chrome"))
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
