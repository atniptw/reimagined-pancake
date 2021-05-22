using System.Threading.Tasks;
using Microsoft.Extensions.Logging;

namespace SEPMakes.Function.Validation
{
    public interface IIdentityValidator
    {
        Task<string> ValidateIdentityToken(string idToken, ILogger logger);
    }
}