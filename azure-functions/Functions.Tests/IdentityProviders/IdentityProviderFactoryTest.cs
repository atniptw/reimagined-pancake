using System;
using Xunit;
using SEPMakes.Function.Validation;
using SEPMakes.Function;
using Moq;
using Microsoft.Extensions.Logging;

namespace Functions.Tests
{
    public class IdentityProviderFactoryTest
    {
        [Theory]
        [InlineData("Google", typeof(GoogleIdentityValidator))]
        public void CreatesIdentityValidator(string identityProvider, Type providerHandler)
        {
            var token = new AuthToken
            {
                SocialIdentityProvider = identityProvider
            };

            var logger = new Mock<ILogger>();
            var config = new Mock<IConfig>();

            var validatorFactory = new IdentityValidatorFactory(config.Object);
            var validator = validatorFactory.GetIdentityValidator(token, logger.Object);

            Assert.Equal(validator.GetType(), providerHandler);
        }

        [Fact]
        public void OnlyCreatesValidatorOnce()
        {
            var token = new AuthToken
            {
                SocialIdentityProvider = "Google"
            };

            var logger = new Mock<ILogger>();
            var config = new Mock<IConfig>();

            var validatorFactory = new IdentityValidatorFactory(config.Object);
            var validator1 = validatorFactory.GetIdentityValidator(token, logger.Object);
            var validator2 = validatorFactory.GetIdentityValidator(token, logger.Object);

            Assert.Same(validator1, validator2);
        }
    }
}
