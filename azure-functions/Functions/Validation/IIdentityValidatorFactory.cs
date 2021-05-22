using Microsoft.Extensions.Logging;

namespace SEPMakes.Function.Validation
{
    public interface IIdentityValidatorFactory
    {
        IIdentityValidator GetIdentityValidator(AuthToken token, ILogger logger);
    }
}