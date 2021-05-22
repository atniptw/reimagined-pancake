using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace SEPMakes.Function.Validation
{
    public class GoogleIdentityValidator : IIdentityValidator
    {
        private readonly IConfig Config;
        public GoogleIdentityValidator(IConfig config)
        {
            Config = config;
        }

        public async Task<string> ValidateIdentityToken(string idToken, ILogger logger)
        {
            try
            {
                var settings = new Google.Apis.Auth.GoogleJsonWebSignature.ValidationSettings()
                {
                    Audience = new List<string>() { Config.Get<string>("GOOGLE_CLIENT_ID") }
                };

                var payload = await Google.Apis.Auth.GoogleJsonWebSignature.ValidateAsync(idToken);
                return payload.Subject;
            }
            catch (Exception e)
            {
                logger.LogError(e.ToString());
                return null;
            }
        }
    }
}