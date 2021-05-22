using Microsoft.Extensions.Configuration;

namespace SEPMakes.Function
{
    public class ConfigurationWrapper : IConfig
    {
        private readonly IConfiguration Configuration;
        public ConfigurationWrapper(IConfiguration configuration) => Configuration = configuration;

        public T Get<T>(string key)
        {
            if (key == null)
            {
                throw new System.Exception("Calling config.get with null or undefined argument");
            }

            T value = Configuration.GetValue<T>(key);

            if (value == null)
            {
                throw new System.Exception($"Configuration property {key} is not defiend");
            }

            return value;
        }
    }
}