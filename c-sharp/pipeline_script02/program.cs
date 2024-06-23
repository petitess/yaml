using Azure.Core;
using Azure.Identity;
using Newtonsoft.Json.Linq;
using System.Net;

namespace ConsolePipeline
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
                  /*      AccessToken token =
                            await new DefaultAzureCredential()
                            .GetTokenAsync(
                                new TokenRequestContext(
                        new[] { "https://management.azure.com/.default" }
                        ));*/
            //{ "https://management.azure.com/.default" }
            //{ "https://vault.azure.net/.default" }

            string token = Environment.GetEnvironmentVariable("AZ_TOKEN");
            string subscriptionId = "2d9f44ea-e3df-4ea1-b956-8c7a43b119a0";

            string subid = subscriptionId;
            string rgname = "rg-owner-prod-01";
            string kvname = "kv-standard-01";
            string secretname = "secret04";
            string apiversion = "2023-07-01";
            string urlAzure = $"https://management.azure.com/subscriptions/{subid}/resourceGroups/{rgname}/" +
                $"providers/Microsoft.KeyVault/vaults/{kvname}/secrets/{secretname}?api-version={apiversion}";

            Console.WriteLine("URL: " + urlAzure);

            var httpRequestAzure = (HttpWebRequest)WebRequest.Create(urlAzure);
            httpRequestAzure.Accept = "application/json";
            httpRequestAzure.Headers["Authorization"] = "Bearer " + token;
            httpRequestAzure.ContentType = "application/json";
            httpRequestAzure.Method = "PUT";
            var streamWriter = new StreamWriter(httpRequestAzure.GetRequestStream());
            var opsgenieJson = JObject.FromObject(new
            {
                properties = new { value = "12341267", contentType = $"{DateTime.Now.ToString("dd-MM-yyyy HH:mm")}" }
            });

            streamWriter.Write(opsgenieJson);
            streamWriter.Flush();
            HttpWebResponse response = (HttpWebResponse)httpRequestAzure.GetResponse();
            var streamReaderAzure = new StreamReader(response.GetResponseStream());
            var resultAzure = streamReaderAzure.ReadToEnd();
            dynamic dataGet = JObject.Parse(resultAzure);
            Console.WriteLine(dataGet);

        }
    }
}
