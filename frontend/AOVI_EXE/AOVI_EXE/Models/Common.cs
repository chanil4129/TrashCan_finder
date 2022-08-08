using AOVI_EXE.Models.Parsing;
using HtmlAgilityPack;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace AOVI_EXE.Models
{
    public class Common
    {
        System.Net.WebClient wc = new System.Net.WebClient();
        List<string> P_data = new List<string>();
        List<string> P_Address = new List<string>();
        public void DataReceived2()     //object sender, System.Windows.Forms.WebBrowserDocumentCompletedEventArgs e
        {
            Global.WebUrl();
            
            Global.url = "https://www.hani.co.kr/arti/politics/politics_general/1052888.html?_ns=t1";
            WebClient client = new WebClient();
            client.Encoding = Encoding.UTF8;
            string htmlstr = client.DownloadString(Global.url);
            HtmlDocument doc = new HtmlDocument();
            doc.LoadHtml(htmlstr);
            HtmlNode bodynode = doc.DocumentNode.SelectSingleNode("//body");


            foreach (HtmlNode aNode in bodynode.SelectNodes("//a | //img | //td | //p | //li"))
            {
                string textData = string.Empty;
                string linkData = string.Empty;
                if (aNode.Name == "a")
                {
                    textData = aNode.InnerText;
                    linkData = aNode.GetAttributeValue("href", "");
                }
                else if (aNode.Name == "img")
                {
                    linkData = aNode.Attributes["src"].Value;

                    string fileName = @"C:\Image\a.png";
                    try
                    {
                        if (DownloadRemoteImageFile(linkData, fileName))
                        {
                            SendData(fileName);
                        }
                    }
                    catch (Exception ex)
                    {

                    }
                }
                else if (aNode.Name == "td")
                    textData = aNode.InnerText;
                else
                    textData = aNode.InnerText;

                P_data.Add(textData);
                P_Address.Add(linkData);
            }
        }

        private bool DownloadRemoteImageFile(string url, string fileName)
        {
            HttpWebRequest requset = (HttpWebRequest)WebRequest.Create(url);

            HttpWebResponse response = (HttpWebResponse)requset.GetResponse();

            bool bImage = response.ContentType.StartsWith("image", StringComparison.OrdinalIgnoreCase);

            if ((response.StatusCode == HttpStatusCode.OK || response.StatusCode == HttpStatusCode.Moved ||
                response.StatusCode == HttpStatusCode.Redirect) && bImage)
            {
                try
                {
                    using (Stream inputStream = response.GetResponseStream())
                    using (Stream outputStream = File.OpenWrite(fileName))
                    {
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        do
                        {
                            bytesRead = inputStream.Read(buffer, 0, buffer.Length);
                            outputStream.Write(buffer, 0, bytesRead);
                        } while (bytesRead != 0);
                    }
                    return true;
                }
                catch (Exception ex)
                {
                    return false;
                }
            }

            return false;
        }

        private void SendData(string path)
        {
            string boundary = "**boundaryline**";
            string serverURL = "http://52.79.202.39/?REQ=api_KAKAO_OCR";

            HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(serverURL);
            webRequest.ContentType = "multipart/form-data; boundary=" + boundary;
            webRequest.Method = "POST"; webRequest.KeepAlive = true;
            try
            {
                var filelist = new List<byte[]>
                {
                    ReadFileToBoundary(path, boundary)
                };
                var endboundary = Encoding.ASCII.GetBytes("\r\n--" + boundary + "--");
                webRequest.ContentLength = filelist.Sum(x => x.Length) + endboundary.Length;
                using (Stream stream = webRequest.GetRequestStream())
                {
                    foreach (var file in filelist)
                    {
                        stream.Write(file, 0, file.Length);
                    }
                    stream.Write(endboundary, 0, endboundary.Length);
                }

                using (var response = webRequest.GetResponse())
                {
                    using (Stream stream2 = response.GetResponseStream())
                    {
                        using (StreamReader reader2 = new StreamReader(stream2))
                        {

                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        private static byte[] ReadFileToBoundary(string filepath, string boundary)
        {
            var boundarybytes = Encoding.ASCII.GetBytes($"\r\n--{boundary}\r\n");
            FileInfo fileInfo = new FileInfo(filepath);

            var header = Encoding.ASCII.GetBytes($"Content-Disposition: form-data; name=\"{fileInfo.Name}\"; filename=\"{fileInfo.Name}\"\r\nContent-Type: application/octet-stream\r\n\r\n");

            using (Stream stream = new MemoryStream())
            {
                stream.Write(boundarybytes, 0, boundarybytes.Length);

                stream.Write(header, 0, header.Length);

                using (Stream fileStream = fileInfo.OpenRead())
                {
                    fileStream.CopyTo(stream);
                }
                var ret = new byte[stream.Length];
                stream.Seek(0, SeekOrigin.Begin);
                stream.Read(ret, 0, ret.Length);
                return ret;
            }
        }
    }
}
