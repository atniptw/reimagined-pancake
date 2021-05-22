using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using SEPMakes.Function.Validation;
using SEPMakes.Function;

namespace auth_function
{
    public class Program
    {
        public static void Main()
        {
            var host = new HostBuilder()
                .ConfigureFunctionsWorkerDefaults()
                .ConfigureServices(s =>
                {
                    s.AddSingleton<IIdentityValidatorFactory, IdentityValidatorFactory>();
                    s.AddSingleton<IConfig, ConfigurationWrapper>();
                })
                .Build();

            host.Run();
        }
    }
}