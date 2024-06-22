using System.Collections;

namespace ConsolePipeline
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string? MyName = Environment.GetEnvironmentVariable("MY_NAME_PWSH");
            Console.WriteLine("Hello, " + MyName);
            Console.WriteLine("CurrentDirectory: " + Environment.CurrentDirectory);
            Console.WriteLine("Platform: " + Environment.OSVersion.Platform);
            Console.WriteLine("MY_NAME_BASH: " + Environment.GetEnvironmentVariable("MY_NAME_BASH"));
            Console.WriteLine("MY_NAME_PWSH: " + Environment.GetEnvironmentVariable("MY_NAME_PWSH"));

            foreach (DictionaryEntry de in Environment.GetEnvironmentVariables())
                Console.WriteLine("  {0} = {1}", de.Key, de.Value);

        }
    }
}
