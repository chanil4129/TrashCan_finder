using AOVI_EXE.Models.Parsing;
using HtmlAgilityPack;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace AOVI_EXE.Models
{
    public class Common
    {
        //public void DataReceived()
        //{
        //    string url = "https://euliciel.tistory.com/15";
        //    HtmlWeb web = new HtmlWeb();
        //    HtmlDocument doc = web.Load(url);
        //    var bodynode = doc.DocumentNode.SelectSingleNode("//body");
        //    HtmlNodeCollection nodes = bodynode.SelectNodes("//div");
        //    HtmlNode firstNode = nodes.First();
        //    string[] text = new string[1000];
        //    int i = 0;
        //    foreach(var node in nodes)
        //    {
        //        text[i++] = node.InnerText;
        //    }

        //    foreach(var receive in text)
        //    {
        //        Console.WriteLine(receive);
        //    }
        //}


        List<string> P_data = new List<string>();
        List<string> P_Address = new List<string>();
        public void DataReceived2()     //object sender, System.Windows.Forms.WebBrowserDocumentCompletedEventArgs e
        {
            try
            {
                //string path = HttpContext.Current.Request.Url.Host;
            }
            catch (Exception ex)
            {

            }
            string url = "https://www.hani.co.kr/arti/politics/politics_general/1052888.html?_ns=t1";
            WebClient client = new WebClient();
            client.Encoding = Encoding.UTF8;
            string htmlstr = client.DownloadString(url);
            HtmlDocument doc = new HtmlDocument();
            doc.LoadHtml(htmlstr);
            HtmlNode bodynode = doc.DocumentNode.SelectSingleNode("//body");


            foreach (HtmlNode aNode in bodynode.SelectNodes("//a | //img | //td | //p"))
            {
                string textData = string.Empty;
                string linkData = string.Empty;
                if (aNode.Name == "a")
                {
                    textData = aNode.InnerText;
                    //linkData = aNode.Attributes["href"].Value;
                }
                else if (aNode.Name == "img")
                {
                    linkData = aNode.Attributes["src"].Value;
                }
                else if (aNode.Name == "td")
                    textData = aNode.InnerText;
                else
                    textData = aNode.InnerText;

                P_data.Add(textData);
                P_Address.Add(linkData);
            }
        }
    }
}
