using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using System.Text.Json;
using System;
using SEPMakes.Function.Validation;

namespace SEPMakes.Function
{
    public class OAuthVerification
    {
        private readonly IIdentityValidatorFactory IdentityValidatorFactory;

        public OAuthVerification(IIdentityValidatorFactory identityValidatorFactory)
        {
            IdentityValidatorFactory = identityValidatorFactory;
        }

        [Function("OAuthVerification")]
        public async Task<HttpResponseData> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequestData req,
            FunctionContext executionContext)
        {
            var logger = executionContext.GetLogger("OAuthVerification");
            logger.LogInformation("C# HTTP trigger function processed a request.");

            try
            {
                string json = await req.ReadAsStringAsync();
                var authToken = JsonSerializer.Deserialize<AuthToken>(json);

                var identityValidator = IdentityValidatorFactory.GetIdentityValidator(authToken, logger);
                var jwtId = await identityValidator.ValidateIdentityToken(authToken.IdToken, logger);

                if (jwtId is not null)
                {
                    var response = req.CreateResponse(HttpStatusCode.OK);
                    response.Headers.Add("Content-Type", "text/plain; charset=utf-8");
                    response.WriteString(jwtId);
                    return response;
                }

                var errorResponse = req.CreateResponse(HttpStatusCode.Forbidden);
                errorResponse.Headers.Add("Content-Type", "text/plain; charset=utf-8");
                errorResponse.WriteString("Invalid JwtId");
                return errorResponse;
            }
            catch (Exception e)
            {
                logger.LogError(e.ToString());

                var response = req.CreateResponse(HttpStatusCode.BadRequest);
                response.Headers.Add("Content-Type", "text/plain; charset=utf-8");
                return response;
            }
        }
    }
}
