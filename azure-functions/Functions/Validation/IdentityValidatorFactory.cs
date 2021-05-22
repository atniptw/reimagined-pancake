using Microsoft.Extensions.Logging;

namespace SEPMakes.Function.Validation
{
    public class IdentityValidatorFactory : IIdentityValidatorFactory
    {
        private GoogleIdentityValidator GoogleIdentityValidator;
        private readonly IConfig Config;

        public IdentityValidatorFactory(IConfig config)
        {
            Config = config;
        }

        public IIdentityValidator GetIdentityValidator(AuthToken token, ILogger logger)
        {
            IIdentityValidator validator = null;
            if (token.SocialIdentityProvider.Equals("Google"))
            {
                validator = CreateGoogleIdentityValidator();
            }

            return validator;
        }

        private IIdentityValidator CreateGoogleIdentityValidator()
        {
            if (GoogleIdentityValidator == null)
            {
                GoogleIdentityValidator = new GoogleIdentityValidator(Config);
            }
            return GoogleIdentityValidator;
        }
    }
}