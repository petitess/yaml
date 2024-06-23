using Azure.Core;
using Azure.Identity;
using Newtonsoft.Json;

namespace ConsolePipeline
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            /*AccessToken token =
                await new DefaultAzureCredential()
                .GetTokenAsync(
                    new TokenRequestContext(
            new[] { "https://management.azure.com/.default" }
            ));*/
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

            HttpClient httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Add("Accept", "application/json");
            httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + token);
            var httpResponseMessage = await httpClient.GetAsync(urlAzure);

            var jsonResult = await httpResponseMessage.Content.ReadAsStringAsync();
            var response = JsonConvert.DeserializeObject(jsonResult);
        
            Console.WriteLine("response: " + response);

        }
    }
}
