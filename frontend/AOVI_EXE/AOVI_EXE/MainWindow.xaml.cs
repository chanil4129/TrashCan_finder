using AOVI_EXE.Models;
using AOVI_EXE.ViewModel;
using System;
using System.Windows;
using System.Windows.Input;


namespace AOVI_EXE
{
    /// <summary>
    /// MainWindow.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            Closing += (s, e) => ViewModelLocator.Cleanup();
            MainWindow window = App.Current.MainWindow as MainWindow;

            Top = Properties.Settings.Default.Top;
            Left = Properties.Settings.Default.Left;
            Width = Properties.Settings.Default.Width;
            Height = Properties.Settings.Default.Height;

            this.KeyDown += MainVeiw_KeyDown;
        }

        void MainVeiw_KeyDown(object sender, KeyEventArgs e)
        {
            try
            {
                if (e.Key.ToString() == "Right")
                {
                    Common com = new Common();
                    com.DataReceived2();
                }
                if (e.Key.ToString() == "Left")
                {

                }
                if(e.Key.ToString() == "Up")
                {

                }
                if (e.Key.ToString() == "Down")
                {

                }
            }
            catch (Exception ex)
            {

            }
        }
    }
}
