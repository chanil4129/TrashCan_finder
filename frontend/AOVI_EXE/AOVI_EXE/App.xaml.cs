using GalaSoft.MvvmLight.Threading;
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
            }
            catch(Exception ex)
            {

            }
        }


        private BackgroundWorker _worker = new BackgroundWorker();

        private void BackGround()
        {
            if (_worker == null)
            {

                _worker = new BackgroundWorker();
                _worker.WorkerReportsProgress = true;
                _worker.WorkerSupportsCancellation = true;

                _worker.DoWork += DoWork;
                _worker.RunWorkerCompleted += RunWorkerCompleted;

                // 작업 시작
                _worker.RunWorkerAsync();
            }
            else
            {
                // 작업 취소
                _worker.CancelAsync();
            }
        }

        public void DoWork(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker worker = sender as BackgroundWorker;

            int count = 10;
            for (int i = 0; i < count; ++i)
            {
                // 작업이 취소 되었을 경우
                if ((worker.CancellationPending == true))
                {
                    e.Cancel = true;
                    break;
                }

                // 작업이 실패 했을 때
                if (_runOption == RunOption.Fail && (i == count / 2))
                {
                    e.Result = "Failed";
                    return;
                }

                // 작업 중 예기치 않은 오류가 발생했을 때
                if (_runOption == RunOption.Error && (i == count / 2))
                {
                    throw new Exception("Custom Error");
                }

                System.Threading.Thread.Sleep(100);

                worker.ReportProgress((i + 1) * 100 / count);
            }
        }

        // 작업 종료 - UI 스레드
        private void RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            string message = "";

            if (e.Cancelled)
            {
                message = "Cancelled";
            }
            else if (e.Error != null)
            {
                message = "Error: " + e.Error.ToString();
            }
            else if (e.Result != null)
            {
                message = e.Result.ToString();
            }
            else
            {
                message = "Success";
            }

            MessageBox.Show(message);

            _worker = null;
        }
    }
}
