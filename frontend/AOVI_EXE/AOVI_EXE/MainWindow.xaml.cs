using AOVI_EXE.Models;
using AOVI_EXE.Models.Parsing;
using AOVI_EXE.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Speech.Synthesis;
using System.Web;
using System.Windows;
using System.Windows.Input;


namespace AOVI_EXE
{
    /// <summary>
    /// MainWindow.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class MainWindow : Window
    {
        System.Windows.Threading.DispatcherTimer timer = new System.Windows.Threading.DispatcherTimer();
        SpeechSynthesizer speechSynthesizer = new SpeechSynthesizer();
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

                if (e.Key.ToString() == "F10")
                {
                    try
                    {

                    }
                    catch (Exception ex)
                    {

                    }
                }
                else if(e.Key.ToString() == "Right" || e.Key.ToString() == "Left")
                {
                    string text = Global.ReceivedData[Global.Textorder].divtd;
                    string link = Global.ReceivedData[Global.Linkorder].ahref;

                    speechSynthesizer.SetOutputToDefaultAudioDevice();
                    
                    speechSynthesizer.SelectVoice("Microsoft Heami Desktop");
                    if (e.Key.ToString() == "Right")
                    {
                        Global.Textorder++;
                        Global.Linkorder++;
                        if (!string.IsNullOrEmpty(link))
                            text += "로 이동을 원하시면 F10을 눌러주세요.";
                        speechSynthesizer.Speak(text);
                    }
                    if (e.Key.ToString() == "Left")
                    {
                        if (Global.Textorder > 0)
                        {
                            Global.Textorder--;
                            Global.Linkorder--;
                            if (!string.IsNullOrEmpty(link))
                                text += "를 원하시면 F10을 눌러주세요.";
                            speechSynthesizer.Speak(text);
                        }

                    }
                }
            }
            catch (Exception ex)
            {

            }
        }
        private void timer_Tick(object sender, System.EventArgs e)
        {

        }
    }
}
